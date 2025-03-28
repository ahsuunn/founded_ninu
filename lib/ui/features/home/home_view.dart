import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/home/widgets/appbar.dart';
import 'package:founded_ninu/ui/features/home/widgets/medicalguide_list.dart';
import 'package:founded_ninu/ui/features/home/widgets/subheader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userName});

  final String userName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(userName: "Ahsan", currentPage: "home"),
      body: Column(
        children: [
          SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.primary, // Background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), // Rounded top left corner
                  topRight: Radius.circular(30), // Rounded top right corner
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
                    padding: EdgeInsets.all(24), // Padding inside the body
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubHeader(
                          icon: Icon(
                            Icons.map_outlined,
                            color: colorScheme.tertiary, // Icon color
                            size: 24,
                          ),
                          title: "Find Hospital",
                        ),

                        SizedBox(height: 10),

                        // MAP
                        Container(
                          width: double.infinity,
                          height: 175,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                Colors.white, // Change this to match the design
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon Placeholder
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10), // Spacing
                              // Text Placeholder
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current location",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    width: 200, // Adjust width as needed
                                    height: 16,
                                    color:
                                        Colors.grey[300], // Placeholder effect
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        //First Aid Guide
                        SubHeader(
                          icon: Icon(
                            Icons.medical_services_outlined,
                            color: colorScheme.tertiary, // Icon color
                            size: 24,
                          ),
                          title: "First Aid Guide",
                        ),
                        SizedBox(height: 10),
                        // Image(image: AssetImage("assets/fa.png")),
                        HorizontalList(),
                        SizedBox(height: 20),

                        // Add more widgets here
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
