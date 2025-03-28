import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/home/widgets/appbar.dart';
import 'package:founded_ninu/ui/features/home/widgets/medicalguide_list.dart';
import 'package:founded_ninu/ui/features/home/widgets/subheader.dart';
import 'package:founded_ninu/ui/features/home/widgets/videocall_container.dart';

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
            child: Stack(
              children: [
                Positioned(
                  top: 0, // Moves the decorative box above
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100, // Adjust height for visibility
                    decoration: BoxDecoration(
                      color: colorScheme.secondary, // Decoration color
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            "Jagalah kesehatan anda dan pastikan melakukan cek kesehatan berkala",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                            maxLines: 2, // Allow only two rows
                            overflow:
                                TextOverflow
                                    .ellipsis, // Show "..." if text is too long
                            softWrap: true, // Enable automatic wrapping
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80, // Move it down by 40px
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primary, // Background color
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), // Rounded top left corner
                        topRight: Radius.circular(
                          20,
                        ), // Rounded top right corner
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
                          padding: EdgeInsets.all(
                            24,
                          ), // Padding inside the body
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
                                      Colors
                                          .white, // Change this to match the design
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              Colors
                                                  .grey[300], // Placeholder effect
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
                              SizedBox(height: 15),

                              SubHeader(
                                icon: Icon(
                                  Icons.video_call_outlined,
                                  color: colorScheme.tertiary, // Icon color
                                  size: 24,
                                ),
                                title: "Video Call Assistance",
                              ),
                              SizedBox(height: 10),
                              VideocallContainer(),

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
          ),
        ],
      ),
    );
  }
}
