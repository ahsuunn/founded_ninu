import 'package:founded_ninu/ui/core/bottom_navbar.dart';
import 'package:founded_ninu/ui/features/home/home_view.dart';
import 'package:go_router/go_router.dart';
import 'package:founded_ninu/ui/features/authentication/signin/signin_view.dart';
import 'package:founded_ninu/ui/features/authentication/signup/signup_view.dart';
import 'package:founded_ninu/ui/features/manual/manual_view.dart';
import 'package:founded_ninu/ui/features/messages/messages_view.dart';
import 'package:founded_ninu/ui/features/profile/profile_view.dart';
import 'package:founded_ninu/ui/features/sirine/sirine_view.dart';

final GoRouter router = GoRouter(
  initialLocation: "/signin", // Change initial location to match ShellRoute
  routes: [
    GoRoute(
      name: "signin",
      path: "/signin",
      builder: (context, state) => SigninPage(),
    ),
    GoRoute(
      name: "signup",
      path: "/signup",
      builder: (context, state) => SignupPage(),
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
            final username = state.pathParameters['username'] ?? "Guest";
            return HomePage(userName: username);
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
