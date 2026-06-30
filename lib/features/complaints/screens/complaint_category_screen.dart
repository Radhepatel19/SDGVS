import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import 'complaint_form_screen.dart';

class ComplaintCategoryScreen extends StatelessWidget {
  const ComplaintCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> categories = [
      {'title': l10n.road, 'icon': Icons.add_road_rounded, 'color': Colors.grey[700]},
      {'title': l10n.water, 'icon': Icons.water_drop_rounded, 'color': Colors.blue},
      {'title': l10n.electricity, 'icon': Icons.electric_bolt_rounded, 'color': Colors.amber},
      {'title': l10n.health, 'icon': Icons.health_and_safety_rounded, 'color': Colors.red},
      {'title': l10n.sanitation, 'icon': Icons.cleaning_services_rounded, 'color': Colors.green},
      {'title': l10n.agriculture, 'icon': Icons.agriculture_rounded, 'color': Colors.brown},
      {'title': l10n.education, 'icon': Icons.school_rounded, 'color': Colors.indigo},
      {'title': l10n.other, 'icon': Icons.more_horiz_rounded, 'color': Colors.blueGrey},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.selectCategory, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
              l10n.issueAbout,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chooseCategoryRoute,
              style: GoogleFonts.outfit(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return _buildCategoryCard(context, cat);
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

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> cat) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComplaintFormScreen(category: cat['title']),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(cat['icon'], size: 40, color: cat['color']),
            const SizedBox(height: 12),
            Text(
              cat['title'],
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
