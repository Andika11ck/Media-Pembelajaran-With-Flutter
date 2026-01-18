import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/splash_screen.dart'; // Import file yang baru kita buat
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // Nyalakan Mesin Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Learning Skripsi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      
      // --- PENGATURAN RUTE HALAMAN ---
      // Halaman pertama yang dibuka adalah splash
      initialRoute: '/', 
      routes: {
        '/': (context) => const SplashScreen(),
        // Kita siapkan rute untuk login, sementara kasih placeholder dulu biar gak error
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}