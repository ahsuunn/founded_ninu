import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/auth_provider.dart';
import 'package:founded_ninu/data/services/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:founded_ninu/ui/core/themes.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.logout_rounded, color: colorScheme.primary),
        title: const Text("Logout"),
        onTap: () async {
          final authService = ref.read(authServiceProvider);
          await authService.signOut();
          ref.invalidate(userProvider);
          if (context.mounted) {
            context.go('/signin');
          }
        },
      ),
    );
  }
}
