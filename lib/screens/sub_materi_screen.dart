import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'materi_detail_screen.dart';

class SubMateriScreen extends StatelessWidget {
  final String babId;
  final String judulBab;

  const SubMateriScreen({
    super.key, 
    required this.babId, 
    required this.judulBab
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judulBab, style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Query mengambil materi berdasarkan Bab
        stream: FirebaseFirestore.instance
            .collection('materi')
            .where('id_bab', isEqualTo: babId) 
            .orderBy('urutan') 
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Empty State
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text("Belum ada materi di bab ini.", style: GoogleFonts.poppins(color: Colors.grey)),
                ],
              ),
            );
          }

          // 3. Data Ready
          final dataMateri = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: dataMateri.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              var materi = dataMateri[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(
                  materi['judul_sub_bab'] ?? 'Tanpa Judul',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                leading: const Icon(Icons.play_circle_outline, color: Colors.blue),
                trailing: const Icon(Icons.arrow_forward, size: 18),
                onTap: () {
                  // --- KIRIM DATA KE DETAIL (TERMASUK KODE KUIS) ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MateriDetailScreen(
                        judul: materi['judul_sub_bab'] ?? "",
                        isi: materi['isi_materi'] ?? "",
                        videoUrl: materi['video_url'] ?? "",
                        // Ambil kode_kuis dari database, kalau null kasih string kosong
                        kodeKuis: materi['kode_kuis'] ?? "", 
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}