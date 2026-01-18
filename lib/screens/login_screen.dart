import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Wajib buat login
import 'package:cloud_firestore/cloud_firestore.dart'; // Wajib buat ambil nama
import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- FUNGSI LOGIN UTAMA ---
  Future<void> _loginUser() async {
    // 1. Ambil inputan user
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // 2. Validasi kalau kosong
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email dan Password tidak boleh kosong!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 3. PROSES LOGIN KE FIREBASE
    try {
      // A. Tampilkan Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // B. Cek Email & Password ke Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // C. Kalau Login Sukses, Ambil Data Profil dari Firestore
      // Kita butuh UID user yang login
      String uid = userCredential.user!.uid;

      // Ambil dokumen di koleksi 'users' yang ID-nya sama dengan UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      // D. Cek apakah datanya ada?
      if (userDoc.exists) {
        // Ambil field 'nama' dari database
        String namaLengkap = userDoc['nama'];

        // Tutup Loading
        if (!mounted) return;
        Navigator.pop(context);

        // Pindah ke Dashboard bawa Nama Asli
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(namaUser: namaLengkap),
          ),
        );
      } else {
        // Jaga-jaga kalau akun ada tapi datanya gak ada (kasus langka)
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(namaUser: "Mahasiswa"),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // --- TANGKAP ERROR LOGIN ---
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading

      String pesanError = "Login Gagal";

      if (e.code == 'user-not-found') {
        pesanError = "Email tidak ditemukan. Daftar dulu ya!";
      } else if (e.code == 'wrong-password') {
        pesanError = "Password salah!";
      } else if (e.code == 'invalid-email') {
        pesanError = "Format email salah.";
      } else if (e.code == 'invalid-credential') {
        pesanError = "Email atau Password salah."; // Error umum Firebase baru
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesanError), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. ICON
                const Icon(Icons.school_rounded, size: 80, color: Colors.blue),
                const SizedBox(height: 20),

                // 2. TEXT JUDUL
                Text(
                  'Selamat Datang!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Silahkan login akun kamu',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // 3. INPUT EMAIL
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

                // 4. INPUT PASSWORD
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
                const SizedBox(height: 10),

                // Lupa Password (Hiasan)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Lupa Password?'),
                  ),
                ),
                const SizedBox(height: 20),

                // 5. TOMBOL MASUK
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loginUser, // Panggil fungsi login di atas
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 6. KE HALAMAN DAFTAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Daftar",
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
      ),
    );
  }
}
