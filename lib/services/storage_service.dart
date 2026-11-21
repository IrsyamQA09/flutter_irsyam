import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Key unik untuk menyimpan data di penyimpanan lokal perangkat
  static const String _keyTotalAktivitas = 'total_aktivitas';

  // 1. Menyimpan data integer secara asynchronous
  static Future<void> saveTotalAktivitas(int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTotalAktivitas, total);
  }

  // 2. Membaca data integer dari penyimpanan lokal (default 0 jika belum ada)
  static Future<int> getTotalAktivitas() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalAktivitas) ?? 0;
  }

  // 3. Menghapus data dari penyimpanan lokal (untuk fitur Reset)
  static Future<void> resetTotalAktivitas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTotalAktivitas);
  }
}