import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String userName;
  final String currentPage; // New: Identify current page

  const MyAppBar({
    super.key,
    required this.userName,
    required this.currentPage, // Pass current page
  });

  @override
  MyAppBarState createState() => MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    final bool isManualPage = widget.currentPage == "manual";

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading:
          isManualPage
              ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              )
              : null,
      title:
          isManualPage
              ? null
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Hi, ",
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                        TextSpan(
                          text: widget.userName,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "We're here to help you!",
                    style: GoogleFonts.lato(fontSize: 16),
                  ),
                ],
              ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isManualPage
                    ? Theme.of(context).colorScheme.primary.withAlpha(
                      125,
                    ) // Darker
                    : Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isManualPage ? null : () => context.pushNamed("manual"),
          child: Row(
            children: [
              Icon(Icons.book, color: Theme.of(context).colorScheme.tertiary),
              Text(
                "Manual",
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            null;
          },
          child: Icon(
            Icons.notifications_active,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
