import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';

import '../../../core/apis/emergency_api.dart';
import '../../../core/services/hive_service.dart';

class EmergencyServicesScreen extends StatefulWidget {
  const EmergencyServicesScreen({super.key});

  @override
  State<EmergencyServicesScreen> createState() => _EmergencyServicesScreenState();
}

class _EmergencyServicesScreenState extends State<EmergencyServicesScreen> {
  List<Map<String, dynamic>> _emergencyNumbers = [];
  bool _isLoading = false;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEmergencyNumbers();
  }

  Future<void> _loadEmergencyNumbers() async {
    setState(() => _isLoading = true);
    final user = HiveService.getUser();
    final admin = HiveService.getAdmin();
    final villageId = user?.villageId ?? admin?.villageId;
    final numbers = await EmergencyApi.getEmergencyNumbers(villageId: villageId);
    if (mounted) {
      setState(() {
        _emergencyNumbers = numbers;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> defaultEmergencies = [
      {
        'title': l10n.ambulance,
        'number': '108',
        'icon': Icons.medical_services_rounded,
        'color': Colors.red,
        'desc': l10n.medicalEmergencies
      },
      {
        'title': l10n.police,
        'number': '100',
        'icon': Icons.local_police_rounded,
        'color': Colors.blue[900],
        'desc': l10n.safetySecurity
      },
      {
        'title': l10n.fireBrigade,
        'number': '101',
        'icon': Icons.local_fire_department_rounded,
        'color': Colors.orange[800],
        'desc': l10n.fireEmergencies
      },
      {
        'title': l10n.villageHelpline,
        'number': '1800-XXX-XXXX',
        'icon': Icons.support_agent_rounded,
        'color': Colors.teal,
        'desc': l10n.panchayatSupport
      },
    ];

    final List<Map<String, dynamic>> emergencies = (_emergencyNumbers.isNotEmpty ? _emergencyNumbers : defaultEmergencies).map((item) {
      // Map backend fields to frontend keys if necessary
      final String number = item['contact_number'] ?? item['number'] ?? '';
      final String desc = item['description'] ?? item['desc'] ?? '';
      
      // Map category to icon and color
      IconData icon;
      Color color;
      
      switch (item['category']?.toString().toLowerCase()) {
        case 'medical':
          icon = Icons.medical_services_rounded;
          color = Colors.red;
          break;
        case 'police':
          icon = Icons.local_police_rounded;
          color = Colors.blue[900]!;
          break;
        case 'fire':
          icon = Icons.local_fire_department_rounded;
          color = Colors.orange[800]!;
          break;
        case 'panchayat':
          icon = Icons.support_agent_rounded;
          color = Colors.teal;
          break;
        default:
          icon = item['icon'] ?? Icons.emergency_rounded;
          color = item['color'] ?? Colors.grey[700]!;
      }

      return {
        ...item,
        'number': number,
        'desc': desc,
        'icon': icon,
        'color': color,
      };
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.emergencyServices, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.red[50],
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.quickHelp,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                      ),
                      Text(
                        l10n.tapCallButton,
                        style: GoogleFonts.outfit(fontSize: 14, color: Colors.red[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: emergencies.length,
              itemBuilder: (context, index) {
                final item = emergencies[index];
                return _buildEmergencyCard(item);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              l10n.stayCalm,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item['icon'], color: item['color'], size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    item['desc'],
                    style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['number'],
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: item['color'],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _makePhoneCall(item['number']),
              style: ElevatedButton.styleFrom(
                backgroundColor: item['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Icon(Icons.call_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
