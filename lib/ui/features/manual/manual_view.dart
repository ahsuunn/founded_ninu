import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/user_provider.dart';
import 'package:founded_ninu/ui/features/home/widgets/appbar.dart';
import 'package:founded_ninu/ui/features/home/widgets/subheader.dart';

class ManualPage extends StatelessWidget {
  ManualPage({super.key});

  final List<Map<String, String>> steps = [
    {"title": "Tap Find Hospital", "image": "assets/manuals/step1.png"},
    {
      "title": "Tap the nearest hospital that we've recommended",
      "image": "assets/manuals/step2.png",
    },
    {"title": "Tap Start", "image": "assets/manuals/step3.png"},
    {
      "title": "You're out of range, get closer to the sirine",
      "image": "assets/manuals/step4.png",
    },
    {
      "title": "Tap Sirine once you're in range",
      "image": "assets/manuals/step5.png",
    },
    {
      "title": "Wait for permission to use sirine",
      "image": "assets/manuals/step6.png",
    },
    {"title": "Tap Activate", "image": "assets/manuals/step7.png"},
    {
      "title": "Slide the bluetooth icon to pair NINU",
      "image": "assets/manuals/step8.png",
    },
    {
      "title": "NINU is connected, Tap power button to activate NINU",
      "image": "assets/manuals/step9.png",
    },
    {"title": "NINU is running", "image": "assets/manuals/step10.png"},
    {
      "title": "Tap Notification Icon to notify nearby people",
      "image": "assets/manuals/step11.png",
    },
    {
      "title": "Tap video call for prehospital assistance",
      "image": "assets/manuals/step12.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(userName: "Ahsan", currentPage: "manual"),
      body: Column(
        children: [
          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                height: 30,
                width: 30,
              ), // Ganti dengan gambar yang kamu unggah
              SizedBox(width: 8),
              Text(
                "NINU",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Manual",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Jarak antara logo dan teks
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0, // Move it down by 40px
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          colorScheme
                              .primary, // Background warna utama (kotak merah)
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tambahkan teks di dalam kotak merah
                              SubHeader(
                                icon: Icon(
                                  Icons.notifications_on_outlined,
                                  color: colorScheme.tertiary, // Icon color
                                  size: 24,
                                ),
                                title: "How to use sirine",
                              ),

                              SizedBox(
                                height: 16,
                              ), // Jarak antara teks dan daftar langkah

                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      childAspectRatio: 1.5,
                                    ),
                                itemCount: steps.length,
                                itemBuilder: (context, index) {
                                  return GuideStepCard(
                                    stepNumber: index + 1,
                                    title: steps[index]["title"]!,
                                    imagePath: steps[index]["image"]!,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GuideStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String imagePath;

  const GuideStepCard({
    required this.stepNumber,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                stepNumber.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Image.asset(imagePath, fit: BoxFit.cover)),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
