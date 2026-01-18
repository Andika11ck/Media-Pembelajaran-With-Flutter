import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAvatar extends StatelessWidget {
  final String nama;
  final double radius;
  final double fontSize;

  const UserAvatar({
    super.key,
    required this.nama,
    this.radius = 28,
    this.fontSize = 20,
  });

  // --- BAGIAN YANG DIPERBAIKI ---
  String _getInitials(String namaLengkap) {
    if (namaLengkap.isEmpty) return "?";

    // 1. Pecah nama jadi list kata
    // "Andika Cahyo Anjay" -> ["Andika", "Cahyo", "Anjay"]
    List<String> words = namaLengkap.trim().split(" ");
    String initials = "";

    // 2. Ambil huruf depan SETIAP kata
    for (var word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toUpperCase();
      }
    }

    // 3. (Opsional) Batasi maksimal 3 huruf biar gak kekecilan
    // Kalau mau ACA (3 huruf), biarin angka di bawah 3.
    // Kalau mau ACAS (4 huruf), ganti jadi 4.
    if (initials.length > 3) {
      initials = initials.substring(0, 3);
    }

    return initials;
  }

  // Fungsi Warna (Tetap sama)
  Color _getBackgroundColor(String namaLengkap) {
    final List<Color> colors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, 
      Colors.purple, Colors.teal, Colors.pink, Colors.indigo,
    ];
    return colors[namaLengkap.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    // Trik: Kalau inisialnya 3 huruf (ACA), font-nya kita kecilin dikit biar muat
    double dynamicFontSize = fontSize;
    String text = _getInitials(nama);
    
    if (text.length > 2) {
      dynamicFontSize = fontSize * 0.7; // Kecilin 30% kalau hurufnya banyak
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: _getBackgroundColor(nama),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: dynamicFontSize, // Pake ukuran dinamis
        ),
      ),
    );
  }
}