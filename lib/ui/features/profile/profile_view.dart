import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/features/profile/widgets/logout_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [LogoutButton()],
        ),
      ),
    );
  }
}
