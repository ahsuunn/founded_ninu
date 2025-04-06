import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/bottom_navbar.dart';
import 'package:founded_ninu/ui/features/authentication/signup/signup_view_2.dart';
import 'package:founded_ninu/ui/features/authentication/signup/signup_view_3.dart';
import 'package:founded_ninu/ui/features/home/home_view.dart';
import 'package:founded_ninu/ui/features/sirine/provider/navigator_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:founded_ninu/ui/features/authentication/signin/signin_view.dart';
import 'package:founded_ninu/ui/features/authentication/signup/signup_view_1.dart';
import 'package:founded_ninu/ui/features/manual/manual_view.dart';
import 'package:founded_ninu/ui/features/messages/messages_view.dart';
import 'package:founded_ninu/ui/features/profile/profile_view.dart';
import 'package:founded_ninu/ui/features/sirine/sirine_view.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: "/signin", // Change initial location to match ShellRoute
    routes: [
      GoRoute(
        name: "signin",
        path: "/signin",
        builder: (context, state) => SigninPage(),
      ),
      GoRoute(
        name: "signup1",
        path: "/signup1",
        builder: (context, state) => FirstSignupPage(),
      ),
      GoRoute(
        name: "signup2",
        path: "/signup2",
        builder: (context, state) => SecondSignupPage(),
      ),
      GoRoute(
        name: "signup3",
        path: "/signup3",
        builder: (context, state) => ThirdSignupPage(),
      ),
      GoRoute(
        name: "manual",
        path: "/manual",
        builder: (context, state) => ManualPage(),
      ),
      GoRoute(
        name: "sirine",
        path: "/sirine",
        builder: (context, state) => SirinePage(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return BottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            name: "home",
            path: "/home/:username",
            builder: (context, state) {
              return HomePage();
            },
          ),
          GoRoute(
            name: "messages",
            path: "/messages",
            builder: (context, state) => MessagesPage(),
          ),
          GoRoute(
            name: "profile",
            path: "/profile",
            builder: (context, state) => ProfilePage(),
          ),
        ],
      ),
    ],
  );
});
