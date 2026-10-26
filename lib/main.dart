import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/firebase_options.dart';
import 'core/theme/app_colors.dart';
import 'presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AlertaCancunApp());
}

class AlertaCancunApp extends StatelessWidget {
  const AlertaCancunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protección Civil Cancún',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.guinda,
          primary: AppColors.guinda,
          secondary: AppColors.dorado,
          surface: const Color(0xFFF4F6F8),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
