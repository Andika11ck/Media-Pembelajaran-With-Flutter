import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Kalau merah, hapus baris ini (kita pake format simpel aja)

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Nilai", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Ambil data riwayat punya user yang login aja
        stream: FirebaseFirestore.instance
            .collection('riwayat_kuis')
            .where('uid', isEqualTo: user?.uid)
            .orderBy('tanggal', descending: true) // Yang terbaru di atas
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 60, color: Colors.grey),
                  Text("Belum ada riwayat kuis.", style: GoogleFonts.poppins(color: Colors.grey)),
                ],
              ),
            );
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var riwayat = data[index].data() as Map<String, dynamic>;
              int nilai = riwayat['nilai'];
              bool lulus = nilai >= 70;
              
              // Format Tanggal Simpel
              String tanggalMentah = riwayat['tanggal'];
              String tanggal = "${tanggalMentah.substring(0, 10)} ${tanggalMentah.substring(11, 16)}";

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: lulus ? Colors.green[100] : Colors.red[100],
                    child: Icon(
                      lulus ? Icons.check : Icons.close,
                      color: lulus ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    "Kuis: ${riwayat['kode_kuis']}", // Misal: Kuis proposisi
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Tanggal: $tanggal",
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  trailing: Text(
                    "$nilai",
                    style: GoogleFonts.poppins(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: lulus ? Colors.blue : Colors.red
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}