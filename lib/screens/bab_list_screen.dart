import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sub_materi_screen.dart'; // Nanti kita buat file ini

class BabListScreen extends StatelessWidget {
  const BabListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Bab", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // StreamBuilder: Alat pemantau database secara Live
      body: StreamBuilder<QuerySnapshot>(
        // 1. Ambil data dari koleksi 'bab', urutkan berdasarkan 'urutan'
        stream: FirebaseFirestore.instance
            .collection('bab')
            .orderBy('urutan') 
            .snapshots(),
        builder: (context, snapshot) {
          // Kalau lagi loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Kalau kosong atau error
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Belum ada materi bab.", style: GoogleFonts.poppins()));
          }

          // Kalau ada datanya, kita ambil dokumennya
          final dataBab = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dataBab.length,
            itemBuilder: (context, index) {
              // Ambil data per baris
              var bab = dataBab[index].data() as Map<String, dynamic>;
              // Ambil ID dokumennya (bab1, bab2, dst) buat dikirim ke halaman sebelah
              String babId = dataBab[index].id; 

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Text("${index + 1}", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(
                    bab['judul_bab'] ?? 'Tanpa Judul',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    bab['deskripsi'] ?? '',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // --- PINDAH KE HALAMAN SUB-BAB ---
                    // Kita kirim ID Bab-nya biar halaman sana tau harus nampilin anak siapa
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubMateriScreen(
                          babId: babId, 
                          judulBab: bab['judul_bab'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}