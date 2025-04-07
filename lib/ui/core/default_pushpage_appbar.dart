import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultPushpageAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const DefaultPushpageAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      automaticallyImplyLeading:
          false, // Prevents Flutter from adding the default back button
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 28,
          ),
          onPressed: () => context.pop(), // Custom back button behavior
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
