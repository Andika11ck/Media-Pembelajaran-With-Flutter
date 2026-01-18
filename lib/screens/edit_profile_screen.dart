import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/user_avatar.dart'; // Import Avatar

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _namaController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  String _previewNama = ""; // Buat preview avatar live

  @override
  void initState() {
    super.initState();
    _loadDataUser();
    
    // Dengerin setiap ketikan user biar avatar berubah langsung
    _namaController.addListener(() {
      setState(() {
        _previewNama = _namaController.text;
      });
    });
  }

  Future<void> _loadDataUser() async {
    if (user != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        setState(() {
          _namaController.text = doc['nama'];
          _previewNama = doc['nama'];
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama wajib diisi")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Cuma update NAMA aja, gak perlu urusan file/storage
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'nama': _namaController.text.trim(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- AVATAR PREVIEW ---
            // Ini bakal berubah huruf & warnanya pas kamu ngetik nama di bawah
            UserAvatar(
              nama: _previewNama.isEmpty ? "?" : _previewNama,
              radius: 60,
              fontSize: 50,
            ),
            
            const SizedBox(height: 10),
            Text(
              "Avatar dibuat otomatis dari nama", 
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)
            ),

            const SizedBox(height: 30),

            // Form Nama
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: "Nama Lengkap",
                hintText: "Contoh: Andika Kusuma",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}