import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sudah punya akun? ", style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () => context.goNamed('signin'),
              child: Text(
                "Sign in",
                style: TextStyle(color: colorScheme.primary, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
