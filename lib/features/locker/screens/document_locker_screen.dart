import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/document_model.dart';
import '../../../core/services/hive_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../core/apis/locker_api.dart';

class DocumentLockerScreen extends StatefulWidget {
  const DocumentLockerScreen({super.key});

  @override
  State<DocumentLockerScreen> createState() => _DocumentLockerScreenState();
}

class _DocumentLockerScreenState extends State<DocumentLockerScreen> {
  List<DocumentModel> _documents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final docs = await LockerApi.getDocuments();
    if (mounted) {
      setState(() {
        _documents = docs;
        _isLoading = false;
      });
    }
  }

  String _searchQuery = '';
  String _selectedCategory = 'all';

  final List<Map<String, dynamic>> _categories = [
    {'id': 'all', 'icon': Icons.all_inclusive_rounded, 'color': Colors.grey},
    {'id': 'aadhaar', 'icon': Icons.badge_rounded, 'color': Colors.blue},
    {'id': 'ration', 'icon': Icons.food_bank_rounded, 'color': Colors.orange},
    {'id': 'income', 'icon': Icons.account_balance_wallet_rounded, 'color': Colors.green},
    {'id': 'land', 'icon': Icons.landscape_rounded, 'color': Colors.brown},
  ];

  String _getCategoryTitle(AppLocalizations l10n, String id) {
    switch (id) {
      case 'aadhaar': return l10n.aadhaarCard;
      case 'ration': return l10n.rationCard;
      case 'income': return l10n.incomeCertificate;
      case 'land': return l10n.landDocuments;
      case 'all': return l10n.all;
      default: return id;
    }
  }

  List<DocumentModel> get _filteredDocuments {
    return _documents.where((doc) {
      final matchesSearch = doc.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'all' || doc.type == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ─── helpers ─────────────────────────────────────────────────────────────────

  /// Returns the right image widget for a filePath that may be a URL or local path.
  Widget _buildDocumentImage(
    String? filePath, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Widget? placeholder,
  }) {
    final fallback = placeholder ??
        const Icon(Icons.description_rounded, color: AppColors.primary, size: 32);

    if (filePath == null || filePath.isEmpty) return fallback;

    if (filePath.startsWith('http')) {
      return Image.network(
        filePath,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          );
        },
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    final file = File(filePath);
    if (file.existsSync()) {
      return Image.file(file, fit: fit, width: width, height: height);
    }

    return fallback;
  }

  // ─── upload ──────────────────────────────────────────────────────────────────

  Future<void> _addDocument(String type, String title, String filePath) async {
    // Build a temporary local DocumentModel to pass to the API.
    final String tempId = 'DOC-${DateTime.now().millisecondsSinceEpoch}';

    // Copy image to app-documents for safe keeping before upload.
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String extension = path.extension(filePath);
    final String permanentPath = path.join(appDocDir.path, '$tempId$extension');

    try {
      await File(filePath).copy(permanentPath);
    } catch (e) {
      debugPrint('Error copying file: $e');
    }

    final localDoc = DocumentModel(
      id: tempId,
      title: title,
      type: type,
      uploadDate: DateTime.now(),
      filePath: permanentPath,
    );

    setState(() => _isLoading = true);

    // Upload to backend — returns the server doc with Cloudinary URL.
    final serverDoc = await LockerApi.uploadDocument(localDoc);

    if (serverDoc != null) {
      // Cache the server doc (has the Cloudinary URL as filePath).
      await HiveService.addDocument(serverDoc);
      _loadDocuments(); // refreshes the list from server + cache
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '"$title" ${AppLocalizations.of(context)!.uploadSuccess}',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload to server. Please try again.')),
        );
      }
    }
  }

  // ─── delete ──────────────────────────────────────────────────────────────────

  Future<void> _deleteDocument(String id) async {
    final success = await LockerApi.deleteDocument(id);
    if (success) {
      await HiveService.deleteDocument(id);
      _loadDocuments();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? AppLocalizations.of(context)!.documentDeleted
                : 'Failed to delete from server',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─── download ────────────────────────────────────────────────────────────────

  Future<void> _downloadDocument(DocumentModel doc) async {
    if (doc.filePath == null || doc.filePath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file available to download.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      late final Uint8List bytes;

      if (doc.filePath!.startsWith('http')) {
        // Download from Cloudinary / remote URL.
        final response = await http.get(Uri.parse(doc.filePath!));
        if (response.statusCode != 200) {
          throw Exception('Server returned ${response.statusCode}');
        }
        bytes = response.bodyBytes;
      } else {
        // Already local.
        final localFile = File(doc.filePath!);
        if (!localFile.existsSync()) throw Exception('Local file not found');
        bytes = await localFile.readAsBytes();
      }

      // Determine a safe file extension.
      final rawExt = doc.filePath!.split('.').last.split('?').first;
      final ext = rawExt.length <= 5 ? rawExt : 'jpg';
      final safeName = doc.title.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(' ', '_');
      final fileName = '${safeName}_${DateTime.now().millisecondsSinceEpoch}.$ext';

      final dir = await getApplicationDocumentsDirectory();
      final savedFile = File('${dir.path}/$fileName');
      await savedFile.writeAsBytes(bytes);

      setState(() => _isLoading = false);

      // Open the saved file.
      final result = await OpenFile.open(savedFile.path);
      if (mounted) {
        if (result.type == ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Saved to: ${savedFile.path}', style: GoogleFonts.outfit()),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File saved but could not open: ${result.message}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ─── view dialog ─────────────────────────────────────────────────────────────

  void _viewDocument(DocumentModel doc) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(doc.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Document image preview ──
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              clipBehavior: Clip.antiAlias,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildDocumentImage(
                  doc.filePath,
                  fit: BoxFit.contain,
                  placeholder: const Center(
                    child: Icon(Icons.description_rounded, size: 64, color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${l10n.type}: ${_getCategoryTitle(l10n, doc.type)}',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('${l10n.id}: ${doc.id}', style: GoogleFonts.outfit(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              '${l10n.uploaded}: ${DateFormat('dd MMM yyyy, hh:mm a').format(doc.uploadDate)}',
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.close, style: GoogleFonts.outfit()),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.download_rounded, size: 18),
            label: Text(l10n.download, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(dialogCtx);
              _downloadDocument(doc);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ─── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.documentLocker, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _loadDocuments,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsCard(l10n),
                      const SizedBox(height: 32),
                      _buildSearchBox(l10n),
                      const SizedBox(height: 32),
                      Text(
                        l10n.categories,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCategorySection(l10n),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.yourDocuments,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            l10n.itemsFound(_filteredDocuments.length),
                            style: GoogleFonts.outfit(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDocumentList(l10n),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadSheet(context, l10n),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          l10n.uploadDocument,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // ─── sub-widgets ─────────────────────────────────────────────────────────────

  Widget _buildSearchBox(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: l10n.searchDocuments,
          hintStyle: GoogleFonts.outfit(color: Colors.grey),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildStatsCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration:
                BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.folder_shared_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.documentsSaved,
                style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.9), fontSize: 14),
              ),
              Text(
                '${_documents.length} ${l10n.items}',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(AppLocalizations l10n) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final bool isSelected = _selectedCategory == cat['id'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['id']),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'], color: isSelected ? Colors.white : cat['color'], size: 28),
                  const SizedBox(height: 8),
                  Text(
                    _getCategoryTitle(l10n, cat['id']),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDocumentList(AppLocalizations l10n) {
    if (_filteredDocuments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(l10n.noDocumentsFound, style: GoogleFonts.outfit(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredDocuments.length,
      itemBuilder: (context, index) {
        final doc = _filteredDocuments[index];
        return InkWell(
          onTap: () => _viewDocument(doc),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                // ── Thumbnail ──
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildDocumentImage(
                      doc.filePath,
                      fit: BoxFit.cover,
                      placeholder: const Icon(
                        Icons.description_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${l10n.uploadedOn} ${DateFormat('dd MMM yyyy').format(doc.uploadDate)}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _viewDocument(doc),
                  icon: const Icon(Icons.visibility_outlined,
                      color: AppColors.primary, size: 20),
                  tooltip: 'View',
                ),
                IconButton(
                  onPressed: () => _downloadDocument(doc),
                  icon: const Icon(Icons.download_rounded,
                      color: AppColors.primary, size: 20),
                  tooltip: 'Download',
                ),
                IconButton(
                  onPressed: () => _deleteDocument(doc.id),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.error, size: 20),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── upload bottom-sheet ─────────────────────────────────────────────────────

  void _showUploadSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.uploadDocument,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.selectDocumentType,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _buildUploadOption(l10n, Icons.badge_rounded, 'aadhaar'),
              _buildUploadOption(l10n, Icons.food_bank_rounded, 'ration'),
              _buildUploadOption(l10n, Icons.account_balance_wallet_rounded, 'income'),
              _buildUploadOption(l10n, Icons.landscape_rounded, 'land'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOption(AppLocalizations l10n, IconData icon, String type) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _showTitleDialog(l10n, type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 16),
            Text(
              _getCategoryTitle(l10n, type),
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }

  void _showTitleDialog(AppLocalizations l10n, String type) {
    final titleController = TextEditingController();
    File? selectedImage;
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(l10n.documentTitle,
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Title field ──
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: l10n.documentTitleHint(_getCategoryTitle(l10n, type)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 20),
                  // ── Image picker ──
                  GestureDetector(
                    onTap: () async {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setDialogState(() => selectedImage = File(image.path));
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(selectedImage!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo_rounded,
                                    color: AppColors.primary, size: 40),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.uploadDocument,
                                  style: GoogleFonts.outfit(color: AppColors.primary),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel, style: GoogleFonts.outfit()),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.fillAllFields)),
                    );
                    return;
                  }
                  if (selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a document image')),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  _addDocument(type, titleController.text.trim(), selectedImage!.path);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.add, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }
}
