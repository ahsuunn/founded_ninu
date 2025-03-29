import 'package:flutter/material.dart';
import 'package:founded_ninu/ui/features/home/widgets/appbar.dart';

class ManualPage extends StatelessWidget {
  const ManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(userName: "Ahsan", currentPage: "manual"),
      body: Center(child: Text("Manual Page")),
    );
  }
}
