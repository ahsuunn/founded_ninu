import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/hospitalname_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/selected_hospital_address_provider.dart';
import 'package:go_router/go_router.dart';

class ArrivalBottomSheet extends ConsumerWidget {
  const ArrivalBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hospitalName = ref.watch(selectedHospitalNameProvider);
    final hospitalAddress = ref.watch(selectedHospitalAddressProvider);
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: colorScheme.primary,
        ),
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Arrival At",
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    hospitalName ?? "tujuan...",
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      textAlign: TextAlign.center,
                      hospitalAddress ?? "...",
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: Row(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.home_filled), Text("Home")],
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
