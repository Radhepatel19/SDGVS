import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../home/screens/home_screen.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/screens/waiting_verification_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final Duration splashDelay;

  const SplashScreen({
    super.key,
    this.splashDelay = const Duration(milliseconds: 2500),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Precache the logo image to prevent initial frame jank
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/sdgvs-icon.png'), context);
    });

    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    if (!mounted) return;
    await Future.delayed(widget.splashDelay);

    final isFirstTime = await AuthService.isFirstTime();

    if (isFirstTime) {
      _goTo(const OnboardingScreen());
      return;
    }

    final isLoggedIn = await AuthService.isLoggedIn();
    final user = await AuthService.getUser();

    if (!isLoggedIn || user == null) {
      _goTo(const LoginScreen());
      return;
    }

    // Direct navigation based on local state for the best user experience
    if (user.isVerified) {
      _goTo(const HomeScreen());
      // Refresh status in background to catch any remote changes
      AuthService.isUserVerified();
    } else {
      _goTo(const WaitingVerificationScreen());
    }
  }

  void _goTo(Widget screen) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   shape: BoxShape.circle,
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.black.withOpacity(0.1),
                  //       blurRadius: 20,
                  //       offset: const Offset(0, 10),
                  //     ),
                  //   ],
                  // ),
                  child: Image.asset(
                    'assets/images/sdgvs-icon.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                Text(
                  'SDGVS',
                  style: GoogleFonts.outfit(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.appName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
