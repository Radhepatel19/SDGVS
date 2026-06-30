import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sdgvs/features/home/screens/home_screen.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import 'core/constants/app_colors.dart';
import 'core/providers/locale_provider.dart';
import 'core/services/hive_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/voice_service.dart';
import 'core/services/contribution_service.dart';
import 'features/onboarding/screens/splash_screen.dart';

final localeProvider = LocaleProvider();
final connectivityService = ConnectivityService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services in parallel to reduce startup time
  await Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
    HiveService.init(),
    connectivityService.init(),
    voiceService.init(),
  ]);
  // Start tracking app usage for contribution points
  contributionService.startTracking();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'Smart Digital Gramin Vikas System',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
            textTheme: GoogleFonts.outfitTextTheme(),
            scaffoldBackgroundColor: AppColors.background,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          locale: const Locale('en'),
          routes: {
            '/': (context) => const SplashScreen(),
            '/main': (context) => const HomeScreen(),
          },
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text('No route for ${settings.name}')),
            ),
          ),
        );
      },
    );
  }
}
