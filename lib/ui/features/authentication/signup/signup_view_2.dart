import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/default_pushpage_appbar.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/signup_provider.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/rolebutton.dart';
import 'package:go_router/go_router.dart';

class SecondSignupPage extends ConsumerWidget {
  const SecondSignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      appBar: DefaultPushpageAppbar(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Siapa anda?", style: TextStyle(fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Rolebutton(
                      onPressed:
                          () => {
                            ref
                                .read(signupProvider.notifier)
                                .updateRole("Pasien"),
                            context.pushNamed("signup3"),
                          },
                      width: buttonWidth,
                      icon: Icon(Icons.face, size: 32),
                      title: "Pasien",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Rolebutton(
                      onPressed:
                          () => {
                            ref
                                .read(signupProvider.notifier)
                                .updateRole("Medis"),
                            context.pushNamed("signup3"),
                          },
                      width: buttonWidth,
                      icon: Icon(Icons.medical_services, size: 32),
                      title: "Tenaga Medis",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
