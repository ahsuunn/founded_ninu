import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CprMedicalGuidePage extends StatelessWidget {
  const CprMedicalGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CPR Guide',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text('''
🚨 First Aid Guide: CPR (Cardiopulmonary Resuscitation)

Kondisi: Korban tidak sadar, tidak bernapas normal, atau tidak bernapas sama sekali.

Langkah-langkah:
  1. Pastikan lokasi aman bagi kamu dan korban.
  2. Periksa respons korban dengan memanggil dan menggoyangkan bahunya.
  3. Minta bantuan dari orang sekitar.
  4. Periksa napas korban selama 10 detik. Jika tidak ada napas atau napas tidak normal, segera mulai CPR.
  5. Lakukan kompresi dada:
      • Tempatkan kedua tangan di tengah dada.
      • Dorong dengan kuat dan cepat (100–120 kali per menit, kedalaman 5–6 cm).
  6. Jika terlatih, berikan 2 napas buatan setelah 30 kompresi.
  7. Hubungi layanan darurat menggunakan aplikasi NINU:
      • Buka aplikasi dan tap “Find Hospital”.
      • Pilih rumah sakit terdekat, lalu tap “Start”.
      • Saat berada dekat lokasi, tap “Sirine” untuk mengaktifkan sinyal darurat.
      • Setelah mendapat izin, tap “Activate”, hubungkan perangkat dengan ikon bluetooth, dan nyalakan sirine.
      • Gunakan fitur notifikasi untuk menarik perhatian sekitar dan video call untuk berkomunikasi langsung dengan tenaga medis.
            ''', style: TextStyle(fontSize: 16, height: 1.6)),
        ),
      ),
    );
  }
}
