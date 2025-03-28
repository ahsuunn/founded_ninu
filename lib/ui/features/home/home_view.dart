import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "Hi, "),
                              TextSpan(
                                text: widget.userName,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text("We're here to help you"),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            iconColor: colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            print("Pressed");
                          },
                          child: Row(
                            children: [
                              Icon(Icons.book),
                              Text(
                                "Manual",
                                style: TextStyle(color: colorScheme.tertiary),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            iconColor: colorScheme.tertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            print("Pressed");
                          },
                          child: Icon(Icons.notifications_active),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                  child: Padding(
                    padding: EdgeInsets.all(24), // Padding inside the body
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(
                                4,
                              ), // Padding around the icon
                              decoration: BoxDecoration(
                                color:
                                    colorScheme
                                        .secondary, // Background color of the box
                                shape: BoxShape.circle, // Makes it a circle
                              ),
                              child: Icon(
                                Icons.map_outlined,
                                color: colorScheme.tertiary, // Icon color
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Find Hospital",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

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
                                color: Colors.black.withOpacity(0.1),
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
