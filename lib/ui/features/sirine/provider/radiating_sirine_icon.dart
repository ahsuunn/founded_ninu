import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/themes.dart';

class RadiatingSirineIcon extends StatefulWidget {
  final VoidCallback onTap;
  const RadiatingSirineIcon({super.key, required this.onTap});

  @override
  State<RadiatingSirineIcon> createState() => _RadiatingSirineIconState();
}

class _RadiatingSirineIconState extends State<RadiatingSirineIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 120 * _scaleAnimation.value,
                  height: 120 * _scaleAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // ignore: deprecated_member_use
                    color: Colors.red.withOpacity(_opacityAnimation.value),
                  ),
                );
              },
            ),
            Icon(Icons.wifi_tethering, color: colorScheme.primary, size: 130),
          ],
        ),
      ),
    );
  }
}
