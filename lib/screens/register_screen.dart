import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Wajib 1
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Wajib 2
import 'dashboard_screen.dart'; // Pastikan file dashboard ada

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller buat ambil teks
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Bersih-bersih memori biar hp gak lemot
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- FUNGSI UTAMA PENDAFTARAN ---
  Future<void> _registerUser() async {
    // 1. Ambil teks dari inputan & bersihkan spasi
    String nama = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPass = _confirmPasswordController.text.trim();

    // 2. Validasi Input Kosong
    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua data wajib diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 3. Validasi Password Sama
    if (password != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password dan Konfirmasi tidak sama!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 4. Validasi Panjang Password (Syarat Firebase minimal 6)
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password minimal 6 karakter!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // --- MULAI PROSES KE SERVER FIREBASE ---
    try {
      // A. Tampilkan Loading Muter-muter
      showDialog(
        context: context,
        barrierDismissible: false, // Gak bisa ditutup paksa
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // B. Buat Akun di Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // C. Ambil ID Unik (UID) user yang baru dibuat
      String uid = userCredential.user!.uid;

      // D. Simpan Nama & Data Lain ke Firestore Database
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'nama': nama,
        'email': email,
        'role': 'mahasiswa',
        'tanggal_daftar': DateTime.now().toIso8601String(),
      });

      // E. Tutup Loading
      if (!mounted) return;
      Navigator.pop(context); // Hilangkan loading

      // F. Tampilkan Pesan Sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi Berhasil! Selamat Datang."),
          backgroundColor: Colors.green,
        ),
      );

      // G. Pindah ke Dashboard & Hapus riwayat halaman login/register
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(namaUser: nama),
        ),
        (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      // --- KALAU ADA ERROR DARI FIREBASE ---
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading dulu

      String pesanError = "Terjadi kesalahan sistem.";
      
      // Terjemahkan error bahasa alien ke bahasa manusia
      if (e.code == 'email-already-in-use') {
        pesanError = "Email ini sudah terdaftar. Silahkan Login.";
      } else if (e.code == 'invalid-email') {
        pesanError = "Format email salah.";
      } else if (e.code == 'weak-password') {
        pesanError = "Password terlalu lemah.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesanError), backgroundColor: Colors.red),
      );

    } catch (e) {
      // --- ERROR LAINNYA ---
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buat Akun Baru',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Lengkapi data diri untuk mulai belajar',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // 1. NAMA LENGKAP
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. EMAIL
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. KONFIRMASI PASSWORD
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Ulangi Password',
                  prefixIcon: const Icon(Icons.lock_reset),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 5. TOMBOL DAFTAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _registerUser, // Panggil fungsi register di atas
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Daftar Sekarang',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Footer login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Balik ke login
                    },
                    child: Text(
                      "Masuk",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}