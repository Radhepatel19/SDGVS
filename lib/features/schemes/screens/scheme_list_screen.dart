import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/scheme_model.dart';
import '../../../core/services/voice_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/apis/scheme_api.dart';
import 'scheme_detail_screen.dart';

class SchemeListScreen extends StatefulWidget {
  final String category;
  const SchemeListScreen({super.key, required this.category});

  @override
  State<SchemeListScreen> createState() => _SchemeListScreenState();
}

class _SchemeListScreenState extends State<SchemeListScreen> {
  List<SchemeModel> _schemes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadSchemes();
  }

  Future<void> _loadSchemes() async {
    setState(() {
      _isLoading = true;
    });

    final schemes = await SchemeApi.getSchemes(category: widget.category);

    if (mounted) {
      setState(() {
        _schemes = schemes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadSchemes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: RefreshIndicator(
                  onRefresh: _loadSchemes,
                  child: _schemes.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(child: Text(l10n.noSchemesAvailable)),
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(24),
                          itemCount: _schemes.length,
                          itemBuilder: (context, index) {
                            final scheme = _schemes[index];
                            return _buildSchemeCard(context, l10n, scheme);
                          },
                        ),
                ),
              ),
            ),
    );
  }

  Widget _buildSchemeCard(
    BuildContext context,
    AppLocalizations l10n,
    SchemeModel scheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SchemeDetailScreen(scheme: scheme),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        scheme.title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _buildListenButton(scheme),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  scheme.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.verified_user_rounded,
                              size: 14, color: Colors.green[700]),
                          const SizedBox(width: 6),
                          Text(
                            l10n.freeScheme,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          l10n.viewDetails,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListenButton(SchemeModel scheme) {
    final isSpeaking =
        voiceService.isPlaying && voiceService.currentlySpeakingId == scheme.id;

    return IconButton(
      onPressed: () async {
        if (isSpeaking) {
          await voiceService.stop();
          setState(() {});
          return;
        }

        await AuthService.getUser();
        final lang = 'en';

        setState(() {}); // Show playing state
        await voiceService.speak(
          "${scheme.title}. ${scheme.description}",
          languageCode: lang,
          id: scheme.id,
        );
        setState(() {}); // Back to idle
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSpeaking
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded,
          size: 16,
          color: isSpeaking ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }
}
