import 'package:flutter/material.dart';

import 'pages/detail_data.dart';

void main() {
  runApp(const CampusGoApp());
}

/// Root Widget aplikasi CampusGo
class CampusGoApp extends StatelessWidget {
  const CampusGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusGo',
      
      // Konfigurasi Tema Aplikasi
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(   
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      
      home: const CampusHomePage(),
    );
  }
}

/// Halaman Utama (StatefulWidget untuk mengelola state counter)
class CampusHomePage extends StatefulWidget {
  const CampusHomePage({super.key});

  @override
  State<CampusHomePage> createState() => _CampusHomePageState();
}

class _CampusHomePageState extends State<CampusHomePage> {
  // State untuk menyimpan jumlah presensi/aktivitas
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

void _navigateToDetail() {
    String nim = '1234567890';
    String name = 'John Doe';

    // Navigator.push untuk berpindah halaman sambil mengirim data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailData(nama: name, nim: nim),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusGo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              
              // Logo / Ikon Utama
              const Icon(Icons.school, size: 80, color: Colors.indigo),
              const SizedBox(height: 16),
              
              // Judul & Subjudul
              const Text(
                'CampusGo',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Mobile Academic Information System',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              
              const SizedBox(height: 24),

              // Kartu Informasi Mahasiswa
              const StudentInfoCard(),

              const SizedBox(height: 24),

              // Tampilan Jumlah Aktivitas / Counter
              Text(
                'Total Aktivitas: $_counter',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              // Custom Button (Primary) untuk menambah counter & tampilkan SnackBar
              CampusButton(
                label: 'Mulai Aktivitas',
                icon: Icons.play_arrow,
                type: CampusButtonType.primary,
                onPressed: () {
                  _incrementCounter();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Aktivitas Berhasil Dimulai!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Contoh Variasi Custom Button (Secondary)
              CampusButton(
                label: 'Lihat Detail',
                type: CampusButtonType.secondary,
                onPressed: () {
                  _navigateToDetail(); // Pindah ke halaman detail dengan data
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================
// WIDGET KARTU INFORMASI MAHASISWA (StudentInfoCard)
// ====================================================
class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Profil
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, size: 32, color: Colors.indigo.shade700),
          ),

          const SizedBox(width: 16),

          // Data Mahasiswa
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Muhammad Sandy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '20260001',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 2),
                Text(
                  'Teknik Informatika',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// WIDGET TOMBOL CUSTOM (CampusButton) & ENUM
// ====================================================
enum CampusButtonType { primary, secondary, tertiary }

class CampusButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final CampusButtonType type;
  final IconData? icon;

  const CampusButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = CampusButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Konten didalam tombol (Ikon + Teks)
    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );

    // Render jenis tombol berdasarkan enum type
    switch (type) {
      case CampusButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );

      case CampusButtonType.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.indigo,
            side: const BorderSide(color: Colors.indigo, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: buttonContent,
        );

      case CampusButtonType.tertiary:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: buttonContent,
        );
    }
  }
}