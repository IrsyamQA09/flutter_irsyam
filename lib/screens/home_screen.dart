import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/absensi_info.dart';
import '../models/student.dart';
import '../services/storage_service.dart';
import '../widgets/absensi_info_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/student_info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  late Future<List<Student>> studentsFuture;
  late Future<AbsensiInfo> absensiFuture;

  @override
  void initState() {
    super.initState();
    _loadSavedCounter();
    studentsFuture = loadStudents();
    absensiFuture = fetchAbsensiInfo();
  }

  // Mengambil data dari StorageService secara asynchronous
  Future<void> _loadSavedCounter() async {
    final savedCounter = await StorageService.getTotalAktivitas();
    if (!mounted) return;
    setState(() {
      _counter = savedCounter;
    });
  }

  // Menambah dan menyimpan total aktivitas ke StorageService
  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await StorageService.saveTotalAktivitas(_counter);
  }

  // Mereset counter di UI dan menghapusnya dari Local Storage
  Future<void> _resetCounter() async {
    await StorageService.resetTotalAktivitas();
    setState(() {
      _counter = 0;
    });
  }

  void reloadStudents() {
    setState(() {
      studentsFuture = loadStudents();
    });
  }

  void reloadAbsensi() {
    setState(() {
      absensiFuture = fetchAbsensiInfo();
    });
  }

  void _navigateToDetail() {
    // Tambahkan navigasi halaman jadwal Anda di sini jika ada
  }

  Future<List<Student>> loadStudents() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/students.json',
    );
    final Map<String, dynamic> decoded =
        jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> studentList = decoded['students'] as List<dynamic>;

    return studentList.map((item) {
      return Student.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  Future<AbsensiInfo> fetchAbsensiInfo() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> listJson = jsonDecode(response.body) as List<dynamic>;
      final Map<String, dynamic> firstItem =
          listJson.first as Map<String, dynamic>;
      return AbsensiInfo.fromJson(firstItem);
    } else {
      throw Exception(
        'Gagal memuat data dari server (Status Code: ${response.statusCode})',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CampusGo')),
      body: FutureBuilder<List<Student>>(
        future: studentsFuture,
        builder: (context, snapshot) {
          // 1. LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ERROR STATE
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 56,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal membaca data mahasiswa.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      label: 'Coba Lagi',
                      onPressed: reloadStudents,
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. MENGAMBIL DATA
          final students = snapshot.data ?? <Student>[];

          // 4. EMPTY STATE
          if (students.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 56),
                  SizedBox(height: 12),
                  Text('Data mahasiswa kosong'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Icon(Icons.school, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'CampusGo',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Mobile Academic Information System'),
                const SizedBox(height: 8),
                Text(
                  'Total Aktivitas: $_counter',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Tambah Aktivitas',
                  icon: Icons.play_arrow,
                  type: CustomButtonType.primary,
                  onPressed: () {
                    _incrementCounter();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Aktivitas Berhasil Dimulai!'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Reset Aktivitas',
                  icon: Icons.refresh,
                  type: CustomButtonType.tertiary,
                  onPressed: () {
                    _resetCounter();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Total Aktivitas Direset!'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Lihat Jadwal',
                  icon: Icons.calendar_today,
                  type: CustomButtonType.secondary,
                  onPressed: _navigateToDetail,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Butuh Bantuan?',
                  icon: Icons.help_outline,
                  type: CustomButtonType.tertiary,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Membuka Pusat Bantuan...')),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // FutureBuilder untuk HTTP GET Info Absensi
                FutureBuilder<AbsensiInfo>(
                  future: absensiFuture,
                  builder: (context, absensiSnapshot) {
                    if (absensiSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (absensiSnapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              'Gagal memuat API Absensi: ${absensiSnapshot.error}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            CustomButton(
                              label: 'Coba Lagi Absensi',
                              onPressed: reloadAbsensi,
                            ),
                          ],
                        ),
                      );
                    }

                    if (absensiSnapshot.hasData) {
                      return AbsensiInfoCard(info: absensiSnapshot.data!);
                    }

                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Mahasiswa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return StudentInfoCard(
                      nim: student.nim,
                      name: student.name,
                      major: student.major,
                      semester: student.semester,
                      email: student.email,
                      attendance: student.attendance,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}