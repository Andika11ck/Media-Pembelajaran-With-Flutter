import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    // Ini Logika Timer:
    // Tunggu 3 detik, lalu pindah halaman.
    Future.delayed(const Duration(seconds: 3), () {
      // Nanti kita arahkan ke LoginScreen di sini.
      // Sementara kita arahkan ke halaman home dummy dulu ya.
      // Kita pakai pushReplacement biar user gak bisa tekan 'Back' ke splash screen
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Warna background biru khas pendidikan
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon Logo (Nanti bisa diganti gambar .png)
            const Icon(
              Icons.school_rounded,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'M-Learning Informatika',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}