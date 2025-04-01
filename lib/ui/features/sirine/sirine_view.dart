import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/core/default_pushpage_appbar.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_screen.dart';

class SirinePage extends StatelessWidget {
  const SirinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultPushpageAppbar(),
      body: Center(child: MapScreen()),
    );
  }
}
