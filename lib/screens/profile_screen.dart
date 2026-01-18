import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'riwayat_screen.dart';
import 'edit_profile_screen.dart';
import '../widgets/user_avatar.dart'; // <--- JANGAN LUPA IMPORT INI

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --- LOGIKA KELUAR (LOGOUT) ---
  Future<void> _logout(BuildContext context) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin keluar dari akun?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Keluar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // --- LOGIKA TOMBOL FITUR (Ssementara) ---
  void _showComingSoon(BuildContext context, String fitur) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Fitur '$fitur' akan segera hadir!"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil User yang sedang login
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // BAGIAN HEADER PROFIL
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: StreamBuilder<DocumentSnapshot>(
                // KITA PAKE STREAM BIAR DATA UPDATE REALTIME
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Default nama kalau loading/error
                  String namaAsli = "Mahasiswa";

                  // Kalau data berhasil diambil
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    namaAsli = data['nama'] ?? "Mahasiswa";
                  }

                  return Column(
                    children: [
                      // --- BAGIAN AVATAR BARU (UserAvatar) ---
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        // Panggil Widget Avatar Canggih Kita
                        child: UserAvatar(
                          nama: namaAsli,
                          radius: 50, // Ukuran Besar buat Profil
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // --- NAMA ASLI ---
                      Text(
                        namaAsli,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      // --- EMAIL ---
                      Text(
                        user?.email ?? "Belum Login",
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // MENU PILIHAN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileItem(Icons.person, "Edit Profil", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  }),
                  _buildProfileItem(Icons.history, "Riwayat Kuis", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiwayatScreen(),
                      ),
                    );
                  }),
                  _buildProfileItem(Icons.lock, "Ganti Password", () {
                    _showComingSoon(context, "Ganti Password");
                  }),
                  _buildProfileItem(Icons.info_outline, "Tentang Aplikasi", () {
                    showAboutDialog(
                      context: context,
                      applicationName: "Skripsi Mobile Learning",
                      applicationVersion: "1.0.0",
                      applicationLegalese: "Dibuat oleh Andika",
                    );
                  }),

                  const SizedBox(height: 20),

                  // TOMBOL LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Keluar Aplikasi",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}