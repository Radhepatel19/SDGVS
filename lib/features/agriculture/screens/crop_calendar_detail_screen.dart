import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/apis/agriculture_api.dart';
import '../../../core/models/crop_calendar_model.dart';

class CropCalendarDetailScreen extends StatefulWidget {
  const CropCalendarDetailScreen({super.key});

  @override
  State<CropCalendarDetailScreen> createState() =>
      _CropCalendarDetailScreenState();
}

class _CropCalendarDetailScreenState extends State<CropCalendarDetailScreen> {
  bool _isLoading = false;
  String? _error;
  List<CropCalendarModel> _crops = [];

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final crops = await AgricultureApi.getCropCalendar();
      if (mounted) { 
        setState(() {
          _crops = crops;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load crop data. Please retry.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final kharifCrops = _crops
        .where(
          (c) =>
              c.season.toLowerCase() == 'monsoon' ||
              c.season.toLowerCase() == 'kharif',
        )
        .toList();
    final rabiCrops = _crops
        .where(
          (c) =>
              c.season.toLowerCase() == 'winter' ||
              c.season.toLowerCase() == 'rabi',
        )
        .toList();
    final summerCrops = _crops
        .where(
          (c) =>
              c.season.toLowerCase() == 'summer' ||
              c.season.toLowerCase() == 'zaid',
        )
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            l10n.cropCalendarDetails,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _loadCrops,
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: l10n.monsoonKharif),
              Tab(text: l10n.winterRabi),
              Tab(text: 'Summer (Zaid)'),
            ],
          ),
        ),
        body: _buildBody(l10n, kharifCrops, rabiCrops, summerCrops),
      ),
    );
  }

  Widget _buildBody(
    AppLocalizations l10n,
    List<CropCalendarModel> kharif,
    List<CropCalendarModel> rabi,
    List<CropCalendarModel> summer,
  ) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, size: 72, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadCrops,
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Retry', style: GoogleFonts.outfit()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: TabBarView(
          children: [
            _buildCropList(l10n, kharif),
            _buildCropList(l10n, rabi),
            _buildCropList(l10n, summer),
          ],
        ),
      ),
    );
  }

  Widget _buildCropList(AppLocalizations l10n, List<CropCalendarModel> crops) {
    if (crops.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grass_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.noCropCalendarFound,
              style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCrops,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: crops.length,
        itemBuilder: (_, index) {
          final crop = crops[index];
          final status = crop.status.toLowerCase();
          final statusColor = status == 'ideal'
              ? Colors.green
              : (status == 'planning' ? Colors.blue : Colors.orange);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.grass_rounded,
                    color: Colors.green[700],
                    size: 24,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        crop.cropName,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        crop.status,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  '${l10n.stageSowing}: ${crop.sowingPeriod}',
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                expandedAlignment: Alignment.topLeft,
                children: [
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailBox(
                          Icons.update_rounded,
                          'Stage',
                          crop.stage,
                        ),
                      ),
                      Expanded(
                        child: _buildDetailBox(
                          Icons.calendar_month_rounded,
                          'Rec. Dates',
                          crop.recommendedDates,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildInfoChip(
                        Icons.timer_outlined,
                        l10n.duration,
                        crop.duration,
                      ),
                      _buildInfoChip(
                        Icons.agriculture_outlined,
                        l10n.harvesting,
                        crop.harvestPeriod,
                      ),
                      _buildInfoChip(
                        Icons.terrain_outlined,
                        l10n.bestSoil,
                        crop.bestSoil,
                      ),
                      _buildInfoChip(
                        Icons.water_drop_outlined,
                        l10n.waterNeed,
                        crop.waterRequirement,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.advisoryNotes,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          crop.description,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailBox(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.green[700]),
            const SizedBox(width: 4),

            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
