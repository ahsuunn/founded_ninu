import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/user_provider.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends ConsumerWidget {
  final Widget child;
  const BottomNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userProvider);

    return Scaffold(
      body: child, // The current page
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            elevation: 0,

            backgroundColor: Colors.white,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            currentIndex: _getCurrentIndex(context),
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/messages');
                  break;
                case 2:
                  context.go('/profile');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final username =
        GoRouterState.of(context).pathParameters['username'] ?? 'Guest';

    if (location == "/home/$username") return 0;
    if (location == "/messages") return 1;
    if (location == "/profile") return 2;
    return 0;
  }
}
