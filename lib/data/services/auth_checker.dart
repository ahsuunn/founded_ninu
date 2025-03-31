import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/auth_provider.dart';
import 'package:founded_ninu/ui/features/authentication/signin/signin_view.dart';
import 'package:founded_ninu/ui/features/home/home_view.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (!context.mounted) {
          return SizedBox.shrink(); // Prevent async gap issue
        }
        return user == null ? SigninPage() : HomePage();
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }
}
