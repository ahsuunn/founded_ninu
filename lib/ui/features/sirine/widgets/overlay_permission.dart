import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:go_router/go_router.dart';

class OverlayPromptWidget extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const OverlayPromptWidget({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Block background interaction
        const ModalBarrier(dismissible: false, color: Colors.black54),

        // Foreground content
        Center(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 24,
                    ), // Reserve space for the X button
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // X button positioned in top-right corner of the container
              Positioned(
                right: 42,
                top: 4,
                child: IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  color: Colors.white,
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
