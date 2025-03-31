import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      child: Row(children: [Icon(Icons.logout_rounded), Text("Logout")]),
      onPressed: () async {
        final authService = ref.read(authServiceProvider);
        await authService.signOut(); // Log out the user
        if (context.mounted) {
          context.go('/signin'); // Navigate back to sign-in page
        }
      },
    );
  }
}
