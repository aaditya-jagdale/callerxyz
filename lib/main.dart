import 'package:callerxyz/modules/local_notifications.dart';
import 'package:callerxyz/onboarding_page.dart';
import 'package:callerxyz/modules/home/screens/home_screen.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  // await FirebaseMessaging.instance.requestPermission();
  // await FirebaseMessaging.instance.getToken();
  await LocalNotifications.init();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'callerXYZ',
        theme: ThemeData(
          fontFamily: 'inter',
          colorScheme: ColorScheme.fromSeed(
              seedColor: CustomColors.black, primary: CustomColors.black),
          useMaterial3: true,
        ),
        home: supabase.auth.currentUser == null
            ? const OnboardingPage()
            : const HomeScreen(),
      ),
    );
  }
}
