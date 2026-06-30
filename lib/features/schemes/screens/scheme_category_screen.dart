import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/apis/scheme_api.dart';
import 'scheme_list_screen.dart';

class SchemeCategoryScreen extends StatefulWidget {
  const SchemeCategoryScreen({super.key});

  @override
  State<SchemeCategoryScreen> createState() => _SchemeCategoryScreenState();
}

class _SchemeCategoryScreenState extends State<SchemeCategoryScreen> {
  List<String> _availableCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await SchemeApi.getAvailableCategories();
    if (mounted) {
      setState(() {
        _availableCategories = categories;
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _getCategoryData(BuildContext context, String categoryName) {
    final l10n = AppLocalizations.of(context)!;
    
    // Map database category names to UI metadata
    final Map<String, Map<String, dynamic>> categoryMap = {
      'Education': {
        'title': l10n.education,
        'icon': Icons.school_rounded,
        'color': Colors.indigo,
      },
      'Agriculture': {
        'title': l10n.farming,
        'icon': Icons.agriculture_rounded,
        'color': Colors.green,
      },
      'Farming': {
        'title': l10n.farming,
        'icon': Icons.agriculture_rounded,
        'color': Colors.green,
      },
      'Pension': {
        'title': l10n.pension,
        'icon': Icons.volunteer_activism_rounded,
        'color': Colors.orange,
      },
      'Health': {
        'title': l10n.health,
        'icon': Icons.health_and_safety_rounded,
        'color': Colors.red,
      },
      'Women Welfare': {
        'title': l10n.womenWelfare,
        'icon': Icons.woman_rounded,
        'color': Colors.pink,
      },
      'Housing': {
        'title': 'Housing',
        'icon': Icons.home_work_rounded,
        'color': Colors.brown,
      },
    };

    return categoryMap[categoryName] ?? {
      'title': categoryName,
      'icon': Icons.category_rounded,
      'color': Colors.blueGrey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.govSchemes,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.exploreCategories,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.browseSchemesByClick,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _availableCategories.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_off_outlined,
                                      size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No active categories found',
                                    style: GoogleFonts.outfit(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _availableCategories.length,
                              itemBuilder: (context, index) {
                                final catName = _availableCategories[index];
                                final catData = _getCategoryData(context, catName);
                                return _buildCategoryItem(context, catData, catName);
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, Map<String, dynamic> cat, String originalName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchemeListScreen(category: originalName),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cat['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(cat['icon'], color: cat['color'], size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  cat['title'],
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
