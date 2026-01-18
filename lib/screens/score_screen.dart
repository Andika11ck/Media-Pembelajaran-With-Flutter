import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart'; // <--- 1. JANGAN LUPA IMPORT INI

class ScoreScreen extends StatefulWidget {
  final int score;
  final int totalSoal;
  final String kodeKuis;

  const ScoreScreen({
    super.key, 
    required this.score, 
    required this.totalSoal,
    this.kodeKuis = "Umum",
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  void initState() {
    super.initState();
    _simpanNilaiKeFirebase();
  }

  Future<void> _simpanNilaiKeFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final nilaiAkhir = (widget.score / widget.totalSoal * 100).toInt();

    await FirebaseFirestore.instance.collection('riwayat_kuis').add({
      'uid': user.uid,
      'email': user.email,
      'kode_kuis': widget.kodeKuis,
      'nilai': nilaiAkhir,
      'benar': widget.score,
      'total_soal': widget.totalSoal,
      'tanggal': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final int nilaiAkhir = (widget.score / widget.totalSoal * 100).toInt();
    bool lulus = nilaiAkhir >= 70;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                lulus ? Icons.emoji_events : Icons.sentiment_dissatisfied, 
                size: 100, 
                color: lulus ? Colors.orange : Colors.grey
              ),
              const SizedBox(height: 20),
              
              Text(
                lulus ? "Selamat! Kamu Lulus" : "Jangan Menyerah!",
                style: GoogleFonts.poppins(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: lulus ? Colors.green : Colors.red,
                ),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                "Nilai Kamu:",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
              
              Text(
                "$nilaiAkhir",
                style: GoogleFonts.poppins(
                  fontSize: 80, 
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              
              Text(
                "Benar ${widget.score} dari ${widget.totalSoal} soal",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // --- BAGIAN TOMBOL YANG DIPERBAIKI ---
              ElevatedButton(
                onPressed: () {
                  // JANGAN PAKE popUntil, TAPI PAKE pushAndRemoveUntil
                  // Artinya: "Buka Dashboard, dan buang semua halaman sebelumnya (Splash, Login, Kuis, dll)"
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      // Kita gak perlu kirim namaUser manual lagi, 
                      // karena Dashboard sekarang udah canggih (ambil sendiri dari database)
                      builder: (context) => const DashboardScreen(), 
                    ),
                    (route) => false, // false artinya: Hapus semua riwayat navigasi
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                ),
                child: Text(
                  "Kembali ke Menu Utama",
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}