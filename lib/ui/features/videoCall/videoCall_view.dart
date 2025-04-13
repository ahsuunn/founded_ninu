import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/hospitalname_provider.dart';
import 'package:go_router/go_router.dart';

class VideoCallPage extends ConsumerStatefulWidget {
  const VideoCallPage({super.key});

  @override
  ConsumerState<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends ConsumerState<VideoCallPage> {
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    // Delay 2 detik untuk simulasi "Calling..."
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        isConnected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isConnected ? _buildConnectedUI() : _buildCallingUI(),
    );
  }

  Widget _buildCallingUI() {
    final hospitalName = ref.watch(selectedHospitalNameProvider);
    return Container(
      color: const Color(0xFF8B2D2D), // Merah tua
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_calling_3, size: 60, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  "Petugas Medis",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  hospitalName ?? "RS Hermina",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Text("Calling..", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back_ios_rounded, size: 28),
              color: Colors.black,
            ),
          ),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildConnectedUI() {
    return Stack(
      children: [
        // Gambar dokter
        Positioned.fill(
          child: Image.asset(
            'assets/assistance.png', // Ganti sesuai path gambar lokal kamu
            fit: BoxFit.cover,
          ),
        ),
        // Appbar atas
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios_rounded, size: 28),
            color: Colors.black,
          ),
        ),
        Positioned(
          top: 45,
          left: MediaQuery.of(context).size.width / 2 - 60,
          child: Text(
            "Petugas Medis",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              fontSize: 18,
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: Icon(Icons.more_vert, color: Colors.black),
        ),
        Positioned(
          top: 40,
          right: 42,
          child: Icon(Icons.add, color: Colors.black),
        ),

        // Video user (kotak kecil)
        Positioned(
          bottom: 120,
          right: 16,
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.people_alt_rounded,
                      size: 48,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.person_2, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'You',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        _buildBottomControls(),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.volume_off, color: Colors.black),
            ),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.videocam, color: Colors.black),
            ),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.mic_off, color: Colors.black),
            ),
            CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.call_end, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
