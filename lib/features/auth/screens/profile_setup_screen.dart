import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/village_model.dart';
import '../../../core/services/village_service.dart';
import 'waiting_verification_screen.dart';
import '../../../core/apis/auth_api.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String mobile;
  final String id;
  const ProfileSetupScreen({super.key, required this.mobile, required this.id});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedOccupation;

  String? _selectedGender;
  DateTime? _selectedDob;
  String? _selectedDistrict;
  String? _selectedTaluka;
  VillageModel? _selectedVillage;
  bool _isLoading = false;
  bool _isLoadingVillages = true;

  List<String> _districts = [];
  List<String> _talukas = [];
  List<VillageModel> _villages = [];

  @override
  void initState() {
    super.initState();
    _loadVillageData();
  }

  Future<void> _loadVillageData() async {
    try {
      final districts = await VillageService.getDistricts();
      setState(() {
        _districts = districts;
        _isLoadingVillages = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingVillages = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading locations: $e')));
      }
    }
  }

  void _onDistrictChanged(String? district) async {
    if (district == null) return;

    setState(() {
      _selectedDistrict = district;
      _selectedTaluka = null;
      _selectedVillage = null;
    });

    try {
      final talukas = await VillageService.getTalukas(district);
      setState(() {
        _talukas = talukas;
        _villages = [];
      });
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading talukas: $e')));
    }
  }

  void _onTalukaChanged(String? taluka) async {
    if (taluka == null || _selectedDistrict == null) return;

    setState(() {
      _selectedTaluka = taluka;
      _selectedVillage = null;
    });

    try {
      final villages = await VillageService.getVillagesByDistrictAndTaluka(
        _selectedDistrict!,
        taluka,
      );
      setState(() {
        _villages = villages;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading villages: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingVillages) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Loading location data...',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildSectionCard(
                    title: "Personal Information",
                    children: [
                      _buildTextField(
                        _nameController,
                        "Full Name *",
                        Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 20),
                      _buildGenderDropdown(),
                      const SizedBox(height: 20),
                      _buildDatePicker(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    title: "Location Information",
                    children: [
                      _buildLocationDropdown(
                        label: "District *",
                        value: _selectedDistrict,
                        items: _districts,
                        icon: Icons.map_outlined,
                        onChanged: _onDistrictChanged,
                      ),
                      const SizedBox(height: 20),
                      _buildLocationDropdown(
                        label: "Taluka *",
                        value: _selectedTaluka,
                        items: _talukas,
                        icon: Icons.location_city_outlined,
                        onChanged: _onTalukaChanged,
                      ),
                      const SizedBox(height: 20),
                      _selectedTaluka != null
                          ? _buildVillageDropdown()
                          : _buildDisabledVillageDropdown(),
                      const SizedBox(height: 20),
                      _buildTextField(
                        _addressController,
                        "Address *",
                        Icons.home_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    title: "Other Information",
                    children: [
                      _buildTextField(
                        _emailController,
                        "Email *",
                        Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      _buildOccupationDropdown(),
                    ],
                  ),
                  const SizedBox(height: 48),
                  _buildSubmitButton(),
                  const SizedBox(height: 40),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Setup Profile",
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Tell us about yourself",
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.outfit(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.7)),
        filled: true,
        fillColor: AppColors.background.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildLocationDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary.withOpacity(0.7)),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ),
            ],
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Row(
                children: [
                  Icon(icon, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(val, style: GoogleFonts.outfit(fontSize: 16)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildVillageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VillageModel>(
          value: _selectedVillage,
          hint: Row(
            children: [
              Icon(
                Icons.home_work_outlined,
                size: 20,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Text(
                "Village Name *",
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ),
            ],
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          items: _villages.map((VillageModel village) {
            return DropdownMenuItem<VillageModel>(
              value: village,
              child: Row(
                children: [
                  Icon(
                    Icons.home_work_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      village.name,
                      style: GoogleFonts.outfit(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (VillageModel? village) {
            setState(() => _selectedVillage = village);
          },
        ),
      ),
    );
  }

  Widget _buildDisabledVillageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 20,
            color: AppColors.primary.withOpacity(0.4),
          ),
          const SizedBox(width: 12),
          Text(
            "Select Taluka first",
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppColors.textSecondary.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: Row(
            children: [
              Icon(
                Icons.person_pin_rounded,
                size: 20,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Text(
                "Select Gender *",
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ),
            ],
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          items: ['Male', 'Female', 'Other'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    value == 'Male'
                        ? Icons.male_rounded
                        : value == 'Female'
                        ? Icons.female_rounded
                        : Icons.person_outline,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(value, style: GoogleFonts.outfit(fontSize: 16)),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) => setState(() => _selectedGender = newValue),
        ),
      ),
    );
  }

  Widget _buildOccupationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedOccupation,
          hint: Row(
            children: [
              Icon(
                Icons.work_outline_rounded,
                size: 20,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Text(
                "Select Occupation *",
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ),
            ],
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
          ),
          items: ['Citizens', 'Students', 'Farmers'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    value == 'Citizens'
                        ? Icons.people_outline_rounded
                        : value == 'Students'
                        ? Icons.school_outlined
                        : Icons.agriculture_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(value, style: GoogleFonts.outfit(fontSize: 16)),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) =>
              setState(() => _selectedOccupation = newValue),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDob ?? DateTime(1990),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => _selectedDob = picked);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: AppColors.primary.withOpacity(0.7),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _selectedDob != null
                  ? DateFormat('dd MMM, yyyy').format(_selectedDob!)
                  : "Date of Birth *",
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: _selectedDob != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _completeRegistration,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  "Complete Registration",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _completeRegistration() async {
    // Validate all required fields
    String? missingField;
    if (_nameController.text.trim().isEmpty) {
      missingField = 'Full Name';
    } else if (_selectedGender == null) {
      missingField = 'Gender';
    } else if (_selectedDob == null) {
      missingField = 'Date of Birth';
    } else if (_selectedDistrict == null) {
      missingField = 'District';
    } else if (_selectedTaluka == null) {
      missingField = 'Taluka';
    } else if (_selectedVillage == null) {
      missingField = 'Village';
    } else if (_addressController.text.trim().isEmpty) {
      missingField = 'Address';
    } else if (_emailController.text.trim().isEmpty) {
      missingField = 'Email';
    } else if (_selectedOccupation == null) {
      missingField = 'Occupation';
    }

    if (missingField != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill $missingField before continuing.'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);

    // Build UserModel with all schema fields including village_id
    final user = UserModel(
      id: widget.id,
      name: _nameController.text.trim(),
      district: _selectedVillage!.district,
      taluka: _selectedVillage!.taluka,
      village: _selectedVillage!.name,
      villageId: _selectedVillage!.id,
      mobile: widget.mobile,
      isRegistered: true,
      isVerified: false,
      email: _emailController.text.trim(),
      occupation: _selectedOccupation,
      gender: _selectedGender,
      dob: _selectedDob,
      address: _addressController.text.trim(),
    );

    final result = await AuthApi.completeProfile(user);

    if (result['success'] == true && mounted) {
      setState(() => _isLoading = false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WaitingVerificationScreen()),
        (route) => false,
      );
    } else if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registration failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
