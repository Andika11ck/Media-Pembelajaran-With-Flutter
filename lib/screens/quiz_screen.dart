import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'score_screen.dart'; // Pastikan file score_screen.dart ada

class QuizScreen extends StatefulWidget {
  final String kodeKuis; // Menerima Kode Unik

  const QuizScreen({super.key, required this.kodeKuis});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> _daftarSoal = [];

  @override
  void initState() {
    super.initState();
    _ambilSoal();
  }

  Future<void> _ambilSoal() async {
    try {
      // QUERY SAKTI: Ambil soal yang kode_kuis-nya COCOK
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('soal')
          .where('kode_kuis', isEqualTo: widget.kodeKuis)
          .get();

      setState(() {
        _daftarSoal = snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _jawabSoal(int indexPilihan) {
    int kunci = _daftarSoal[_currentIndex]['kunci_jawaban']; // Pastikan di firebase field-nya number (0,1,2,3)

    if (indexPilihan == kunci) {
      _score++;
    }

    setState(() {
      if (_currentIndex < _daftarSoal.length - 1) {
        _currentIndex++;
      } else {
        // SELESAI -> PINDAH KE SKOR
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ScoreScreen(
              score: _score,
              totalSoal: _daftarSoal.length,
              kodeKuis: widget.kodeKuis,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_daftarSoal.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Kuis"), backgroundColor: Colors.blue, foregroundColor: Colors.white),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
              const SizedBox(height: 10),
              Text("Soal kuis belum diinput.", style: GoogleFonts.poppins(color: Colors.grey)),
              Text("(Kode: ${widget.kodeKuis})", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final soalAktif = _daftarSoal[_currentIndex];
    List<dynamic> opsi = soalAktif['opsi_jawaban']; // Pastikan di firebase tipe Array

    return Scaffold(
      appBar: AppBar(
        title: Text("Kuis Sesi Ini", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false, // Gak boleh kabur pas kuis
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _daftarSoal.length,
              backgroundColor: Colors.grey[200],
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            
            Text(
              "Soal ${_currentIndex + 1} dari ${_daftarSoal.length}",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            
            // Pertanyaan
            Text(
              soalAktif['pertanyaan'],
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            // Tombol Jawaban
            ...opsi.asMap().entries.map((entry) {
              int idx = entry.key;
              String text = entry.value.toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  onPressed: () => _jawabSoal(idx),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    alignment: Alignment.centerLeft, // Teks rata kiri biar rapi
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "${String.fromCharCode(65 + idx)}. $text", // Jadi A. B. C. D.
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}