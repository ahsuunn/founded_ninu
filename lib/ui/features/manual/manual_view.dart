import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/user_provider.dart';
import 'package:founded_ninu/ui/features/home/widgets/appbar.dart';

class ManualPage extends ConsumerWidget {
  const ManualPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: Center(child: Text("Manual Page")),
    );
  }
}
