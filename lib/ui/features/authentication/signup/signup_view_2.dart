import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/features/authentication/signup/state/provider.dart';
import 'package:founded_ninu/ui/features/authentication/widgets/rolebutton.dart';
import 'package:go_router/go_router.dart';

class SecondSignupPage extends ConsumerWidget {
  const SecondSignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Prevents Flutter from adding the default back button
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () => context.pop(), // Custom back button behavior
          ),
        ),
      ),
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
                            ref.read(roleProvider.notifier).state = "Pasien",
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
                            ref.read(roleProvider.notifier).state = "Medis",
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
