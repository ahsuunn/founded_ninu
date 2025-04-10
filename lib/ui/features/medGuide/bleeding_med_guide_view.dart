import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BleedingMedicalGuidePage extends StatelessWidget {
  const BleedingMedicalGuidePage({super.key});

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
          'Bleeding Guide',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text('''
🩸 First Aid Guide: Pendarahan Parah

Kondisi: Luka besar dengan pendarahan yang terus-menerus.

Langkah-langkah:
  1. Pastikan area aman sebelum mendekati korban.
  2. Kenakan sarung tangan, jika tersedia.
  3. Tekan luka dengan kain bersih atau perban, tahan terus tanpa mengangkatnya.
  4. Angkat area yang terluka, jika memungkinkan, di atas posisi jantung.
  5. Tambahkan tekanan lebih kuat atau lapisan kain tambahan jika darah masih keluar.
  6. Jika korban pucat atau lemah, baringkan dan jaga tetap hangat.
  7. Hubungi layanan darurat menggunakan aplikasi NINU:
      • Buka aplikasi dan tap “Find Hospital”.
      • Pilih rumah sakit terdekat, lalu tap “Start”.
      • Saat mendekati lokasi, tap “Sirine” untuk memulai permintaan bantuan.
      • Setelah mendapat izin, tap “Activate”, sambungkan dengan bluetooth, dan aktifkan sirine.
      • Gunakan ikon notifikasi dan fitur video call untuk mempercepat penanganan dari pihak rumah sakit.
            ''', style: TextStyle(fontSize: 16, height: 1.6)),
        ),
      ),
    );
  }
}
