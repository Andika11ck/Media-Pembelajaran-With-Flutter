class Soal {
  final String pertanyaan;
  final List<String> opsiJawaban; // List pilihan A, B, C, D
  final int indexJawabanBenar;    // 0=A, 1=B, 2=C, 3=D

  Soal({
    required this.pertanyaan,
    required this.opsiJawaban,
    required this.indexJawabanBenar,
  });
}

// DATA DUMMY SOAL (Contoh Soal Algoritma)
List<Soal> listSoalAlgoritma = [
  Soal(
    pertanyaan: "Apa yang dimaksud dengan Algoritma?",
    opsiJawaban: [
      "Bahasa pemrograman paling sulit",
      "Urutan langkah logis penyelesaian masalah",
      "Komponen fisik komputer",
      "Aplikasi pembuat video",
    ],
    indexJawabanBenar: 1, // Jawaban benar adalah opsi ke-2 (Index 1)
  ),
  Soal(
    pertanyaan: "Manakah simbol flowchart untuk 'Proses'?",
    opsiJawaban: [
      "Persegi Panjang",
      "Belah Ketupat",
      "Lingkaran",
      "Jajar Genjang",
    ],
    indexJawabanBenar: 0, // Persegi Panjang
  ),
  Soal(
    pertanyaan: "Struktur kontrol untuk perulangan disebut...",
    opsiJawaban: [
      "Sequence",
      "Selection",
      "Looping",
      "Debugging",
    ],
    indexJawabanBenar: 2, // Looping
  ),
];