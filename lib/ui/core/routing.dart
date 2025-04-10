import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/auth_provider.dart';
import 'package:founded_ninu/ui/core/bottom_navbar.dart';
import 'package:founded_ninu/ui/features/authentication/signup/signup_view_2.dart';
import 'package:founded_ninu/ui/features/authentication/signup/signup_view_3.dart';
import 'package:founded_ninu/ui/features/home/home_view.dart';
import 'package:founded_ninu/ui/features/medGuide/CprMedGuide_view.dart';
import 'package:founded_ninu/ui/features/medGuide/bleeding_med_guide_view.dart';
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
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: "/home",
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;

      final user = authState.value;
      final currentLocation = state.uri.toString(); // fallback for .subloc

      final isLoggingIn = currentLocation == '/signin';

      if (user == null && !isLoggingIn) {
        return '/signin';
      }

      if (user != null && isLoggingIn) {
        return '/home';
      }

      return null;
    }, // Change initial location to match ShellRoute
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
      GoRoute(
        name: "cprmedguide",
        path: "/cprGuide",
        builder: (context, state) => CprMedicalGuidePage(),
      ),
      GoRoute(
        name: "bleedingmedguide",
        path: "/bleedingGuide",
        builder: (context, state) => BleedingMedicalGuidePage(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return BottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            name: "home",
            path: "/home",
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
