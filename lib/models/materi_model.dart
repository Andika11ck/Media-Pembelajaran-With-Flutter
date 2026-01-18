class Materi{
  final String judul;
  final String deskripsi;
  final String gambarUrl;
  final String isiMateri;

  Materi({
    required this.judul,
    required this.deskripsi,
    required this.gambarUrl,
    required this.isiMateri,
  });
}

List<Materi> listMateriProgramming = [
  Materi(
    judul: "Pengenalan Algoritma",
    deskripsi: "Belajar dasar logika pemrograman dan flowchart.",
    gambarUrl: "assets/algo.png",
    isiMateri: """
Algoritma adalah urutan langkah-langkah logis untuk menyelesaikan masalah. 
Bayangkan resep masakan, itu adalah algoritma!

Ada 3 struktur dasar algoritma:
1. Runtutan (Sequence): Langkah berurutan dari atas ke bawah.
2. Percabangan (Selection): Memilih langkah berdasarkan kondisi (Jika... Maka...).
3. Perulangan (Looping): Mengulang langkah sampai tujuan tercapai.

Kenapa algoritma penting? Karena komputer itu bodoh. Dia hanya melakukan apa yang kita suruh secara detail.
""",
  ),
  Materi(
    judul: "Variabel & Tipe Data",
    deskripsi: "Memahami cara menyimpan data dalam memori komputer.",
    gambarUrl: "assets/var.png",
    isiMateri: "Variabel ibarat wadah atau toples untuk menyimpan makanan (data). Tipe data adalah jenis makanannya...",
  ),
  Materi(
    judul: "Variabel & Tipe Data",
    deskripsi: "Memahami cara menyimpan data dalam memori komputer.",
    gambarUrl: "assets/var.png",
    isiMateri: "Variabel ibarat wadah atau toples untuk menyimpan makanan (data). Tipe data adalah jenis makanannya...",
  ),
  Materi(
    judul: "Percabangan (If-Else)",
    deskripsi: "Membuat program bisa memilih keputusan.",
    gambarUrl: "assets/if.png",
    isiMateri: "Percabangan memungkinkan program untuk membuat keputusan berdasarkan kondisi tertentu. Misalnya, jika hujan, maka bawa payung...",
  ),
  Materi(
    judul: "Perulangan (Looping)",
    deskripsi: "Melakukan tugas berulang kali secara otomatis.",
    gambarUrl: "assets/loop.png",
    isiMateri: "Perulangan memungkinkan kita untuk menjalankan blok kode yang sama berulang kali sampai kondisi tertentu terpenuhi. Contohnya, mencetak angka dari 1 sampai 10...",
  ),
  Materi(
    judul: "Function & Method",
    deskripsi: "Meringkas kode menjadi blok-blok kecil.",
    gambarUrl: "assets/func.png",
    isiMateri: "Function (fungsi) adalah blok kode yang dirancang untuk melakukan tugas tertentu. Bayangkan fungsi sebagai mesin yang menerima input, memprosesnya, dan menghasilkan output...",
  ),
];
