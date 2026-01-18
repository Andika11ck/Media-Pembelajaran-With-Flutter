import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; 
import 'quiz_screen.dart'; 

class MateriDetailScreen extends StatefulWidget {
  final String judul;
  final String isi;
  final String videoUrl;
  final String kodeKuis;

  const MateriDetailScreen({
    super.key,
    required this.judul,
    required this.isi,
    required this.videoUrl,
    required this.kodeKuis,
  });

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
          enableCaption: false,
        ),
      )..addListener(() {
          if (mounted) setState(() {});
        });
      setState(() {
        _isPlayerReady = true;
      });
    }
  }

  @override
  void dispose() {
    if (_isPlayerReady) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Materi Belajar", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================
            // 1. VIDEO PLAYER (Tetap)
            // =========================================
            SizedBox(
              width: double.infinity,
              child: _isPlayerReady
                  ? YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blue,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(
                        child: Text("Memuat Video...", style: GoogleFonts.poppins()),
                      ),
                    ),
            ),

            // JUDUL
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.judul,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const Divider(thickness: 1),
                ],
              ),
            ),

            // =========================================
            // 2. 3D MODEL LOCAL ASSET (YANG DIUBAH)
            // =========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Petunjuk
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.touch_app, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          "Geser objek 3D untuk melihat detail",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Container 3D Model
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: const ModelViewer(
                        // 🔴 BAGIAN PENTING: GANTI KE LOKAL 🔴
                        // Pastikan nama file di folder assets sama persis!
                        src: 'assets/models/materi_3d.glb', 
                        
                        // Settings Interaksi
                        autoRotate: true,
                        cameraControls: true,
                        backgroundColor: Colors.transparent,
                        alt: "Model 3D Interaktif",
                        ar: false, 
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =========================================
            // 3. ISI MATERI (Tetap)
            // =========================================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.isi,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            
            const SizedBox(height: 80),
          ],
        ),
      ),

      // TOMBOL KUIS
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), 
              blurRadius: 10, 
              offset: const Offset(0, -5)
            )
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            if (widget.kodeKuis.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kuis belum tersedia.")),
              );
            } else {
              if (_isPlayerReady) _controller.pause();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(kodeKuis: widget.kodeKuis),
                ),
              );
            }
          },
          icon: const Icon(Icons.quiz, color: Colors.white),
          label: Text(
            "Mulai Kuis", 
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}