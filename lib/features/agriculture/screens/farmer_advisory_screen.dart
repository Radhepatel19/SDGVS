import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/apis/agriculture_api.dart';
import '../../../core/apis/weather_api.dart';
import '../../../core/apis/agri_notice_api.dart';
import '../../../core/models/crop_calendar_model.dart';
import '../../../core/models/agri_resource_model.dart';
import '../../../core/models/mandi_price_model.dart';
import '../../../core/models/weather_alert_model.dart';
import '../../../core/models/agri_notice_model.dart';
import 'crop_calendar_detail_screen.dart';
import 'mandi_prices_detail_screen.dart';

class FarmerAdvisoryScreen extends StatefulWidget {
  const FarmerAdvisoryScreen({super.key});

  @override
  State<FarmerAdvisoryScreen> createState() => _FarmerAdvisoryScreenState();
}

class _FarmerAdvisoryScreenState extends State<FarmerAdvisoryScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  List<CropCalendarModel> _crops = [];
  List<MandiPriceModel> _prices = [];
  List<AgriResourceModel> _resources = [];
  List<WeatherAlertModel> _weatherAlerts = [];
  List<AgriNoticeModel> _notices = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        AgricultureApi.getCropCalendar(),
        AgricultureApi.getMandiPrices(),
        AgricultureApi.getAgriResources(),
        WeatherApi.getActiveAlerts(),
        AgriNoticeApi.getNotices(),
      ]);

      if (mounted) {
        setState(() {
          _crops = (results[0] as List<CropCalendarModel>).take(5).toList();
          _prices = (results[1] as List<MandiPriceModel>).take(4).toList();
          _resources = results[2] as List<AgriResourceModel>;
          _weatherAlerts = results[3] as List<WeatherAlertModel>;
          _notices = (results[4] as List<AgriNoticeModel>).take(3).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not load data. Please check your connection.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.farmerAdvisoryBoard,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, size: 72, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
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
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Weather Alerts ──
                _buildWeatherAlerts(l10n),
                if (_weatherAlerts.isNotEmpty) const SizedBox(height: 24),

                // ── Crop Calendar ──
                _buildSectionTitle(
                  l10n,
                  l10n.cropCalendarDetails,
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CropCalendarDetailScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildCropCalendar(l10n),
                const SizedBox(height: 32),

                // ── Mandi Prices ──
                _buildSectionTitle(
                  l10n,
                  l10n.marketMandiPrices,
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MandiPricesDetailScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildMandiPrices(l10n),
                const SizedBox(height: 32),

                // ── Resources ──
                _buildSectionTitle(l10n, l10n.resourcesAvailability),
                const SizedBox(height: 12),
                _buildResourceAvailability(l10n),
                const SizedBox(height: 32),

                // ── Agri Notices ──
                _buildSectionTitle(l10n, l10n.departmentalNotices),
                const SizedBox(height: 12),
                _buildAgriNotices(l10n),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION HEADER
  // ─────────────────────────────────────────────
  Widget _buildSectionTitle(
    AppLocalizations l10n,
    String title, {
    VoidCallback? onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              l10n.viewAll,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // WEATHER ALERTS
  // ─────────────────────────────────────────────
  Widget _buildWeatherAlerts(AppLocalizations l10n) {
    if (_weatherAlerts.isEmpty) return const SizedBox.shrink();
    return Column(
      children: _weatherAlerts.map((a) => _buildAlertItem(a)).toList(),
    );
  }

  Widget _buildAlertItem(WeatherAlertModel alert) {
    final color = alert.level == 'critical'
        ? Colors.red
        : alert.level == 'warning'
            ? Colors.orange
            : Colors.blue;
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(alert.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            content: Text(alert.message, style: GoogleFonts.outfit()),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              alert.level == 'critical'
                  ? Icons.error_outline_rounded
                  : Icons.warning_amber_rounded,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    alert.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CROP CALENDAR
  // ─────────────────────────────────────────────
  Widget _buildCropCalendar(AppLocalizations l10n) {
    if (_crops.isEmpty) {
      return _buildEmptyCard(l10n.noCropCalendarFound, Icons.grass_outlined);
    }
    return Container(
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
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _crops.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final crop = _crops[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
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
            title: Text(
              crop.cropName,
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${crop.stage} • ${crop.season}',
              style: GoogleFonts.outfit(fontSize: 12),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: crop.status.toLowerCase() == 'ideal'
                    ? Colors.green[100]
                    : Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                crop.status,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: crop.status.toLowerCase() == 'ideal'
                      ? Colors.green[700]
                      : Colors.blue[700],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MANDI PRICES
  // ─────────────────────────────────────────────
  Widget _buildMandiPrices(AppLocalizations l10n) {
    if (_prices.isEmpty) {
      return _buildEmptyCard(l10n.noMandiPricesFound, Icons.store_outlined);
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: _prices.length,
      itemBuilder: (_, index) {
        final price = _prices[index];
        final status = price.status.toLowerCase();
        final isUp = status == 'up';
        final isDown = status == 'down';

        final trendColor = isUp
            ? Colors.green
            : (isDown ? Colors.red : Colors.grey);
        final trendIcon = isUp
            ? Icons.trending_up_rounded
            : (isDown
                  ? Icons.trending_down_rounded
                  : Icons.trending_flat_rounded);

        return Container(
          padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price.cropName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    price.mandi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price.price,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        price.change,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: trendColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(trendIcon, size: 18, color: trendColor),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // RESOURCE AVAILABILITY
  // ─────────────────────────────────────────────
  Widget _buildResourceAvailability(AppLocalizations l10n) {
    if (_resources.isEmpty) {
      return _buildEmptyCard(
        l10n.noAgriResourcesFound,
        Icons.inventory_2_outlined,
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _resources.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) {
          final res = _resources[index];
          Color color;
          switch (res.statusColor.toLowerCase()) {
            case 'red':
              color = Colors.red;
              break;
            case 'orange':
              color = Colors.orange;
              break;
            default:
              color = Colors.green;
          }
          return _buildResourceRow(
            res.resourceName,
            res.availabilityPercent,
            color,
          );
        },
      ),
    );
  }

  Widget _buildResourceRow(String title, String pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
            Text(
              pct,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (double.tryParse(pct.replaceAll('%', '')) ?? 0) / 100,
            backgroundColor: color.withValues(alpha : 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // AGRI NOTICES
  // ─────────────────────────────────────────────
  Widget _buildAgriNotices(AppLocalizations l10n) {
    if (_notices.isEmpty) {
      return _buildEmptyCard(
        l10n.noNoticesFound,
        Icons.notifications_none_rounded,
      );
    }
    return Column(
      children: _notices.map((n) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.green[50]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.info_outline_rounded,
                        size: 16, color: Colors.green[700]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      n.title,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                n.message,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }


  // ─────────────────────────────────────────────
  // SHARED EMPTY STATE
  // ─────────────────────────────────────────────
  Widget _buildEmptyCard(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
