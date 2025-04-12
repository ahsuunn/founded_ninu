import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/user_provider.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/home/widgets/appbar.dart';
import 'package:founded_ninu/ui/features/home/widgets/map_snippet.dart';
import 'package:founded_ninu/ui/features/home/widgets/medicalguide_list.dart';
import 'package:founded_ninu/ui/features/home/widgets/subheader.dart';
import 'package:founded_ninu/ui/features/home/widgets/videocall_container.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  String fullname = '';

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: userAsync.when(
        data:
            (user) => MyAppBar(
              userName: (user?.fullName ?? "No Name"),
              currentPage: "home",
            ),
        loading: () => MyAppBar(userName: "", currentPage: "home"),
        error: (err, stack) => MyAppBar(userName: "Error", currentPage: "home"),
      ),
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
                              GestureDetector(
                                onTap: () => context.pushNamed("sirine"),
                                child: MapSnippet(),
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
                              SizedBox(height: 16),

                              SubHeader(
                                icon: Icon(
                                  Icons.video_call_outlined,
                                  color: colorScheme.tertiary, // Icon color
                                  size: 22,
                                ),
                                title: "Video Call Assistance",
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => context.push('/videocall'),
                                child: VideocallContainer(),
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
