import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_screen.dart';
import 'bab_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/user_avatar.dart'; // <--- Pastikan ini sudah di-import

class DashboardScreen extends StatefulWidget {
  final String namaUser;

  const DashboardScreen({super.key, this.namaUser = "Mahasiswa"});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(nama: widget.namaUser),
      const BabListScreen(), // Tab Tengah langsung buka Materi
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Materi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
      ),
    );
  }
}

// --- ISI DASHBOARD KHUSUS INFORMATIKA ---
class HomeContent extends StatelessWidget {
  final String nama;
  const HomeContent({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    // Ambil ID user yang lagi login
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'MOLE X INFORMATIKA',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER SAPAAN (STREAM BUILDER KITA TARUH DI SINI)
          // Biar dia membungkus AVATAR dan TEXT sekaligus
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              String namaTampil = nama; // Default awal

              // Kalau data berhasil diambil dari database
              if (snapshot.hasData && snapshot.data!.exists) {
                var data = snapshot.data!.data() as Map<String, dynamic>;
                namaTampil = data['nama'] ?? nama;
              }

              return Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    // --- AVATAR CANGGIH (UserAvatar) ---
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white, 
                        shape: BoxShape.circle
                      ),
                      // Sekarang Avatar juga pake 'namaTampil' yang live dari database
                      child: UserAvatar(
                        nama: namaTampil, 
                        radius: 28,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    // --- TEKS SAPAAN ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $namaTampil 👋',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Siap belajar koding hari ini?',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // 2. JUDUL BAGIAN
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Materi Informatika",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          // 3. GRID MENU
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _buildMenuCard(
                  context,
                  Icons.psychology,
                  "Berpikir\nKomputasional",
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BabListScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  Icons.computer,
                  "Teknologi\nTIK",
                  Colors.blue,
                  () => _showComingSoon(context, "Materi TIK"),
                ),
                _buildMenuCard(
                  context,
                  Icons.memory,
                  "Sistem\nKomputer",
                  Colors.green,
                  () => _showComingSoon(context, "Sistem Komputer"),
                ),
                _buildMenuCard(
                  context,
                  Icons.wifi,
                  "Jaringan &\nInternet",
                  Colors.purple,
                  () => _showComingSoon(context, "Jaringan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String judul) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$judul akan segera hadir!"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}