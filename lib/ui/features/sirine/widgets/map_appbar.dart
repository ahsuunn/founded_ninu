import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_controller.dart';
import 'package:go_router/go_router.dart';

class MapAppbar extends ConsumerWidget implements PreferredSizeWidget {
  final MapController mapController;
  const MapAppbar({required this.mapController, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placemarkAsync = ref.watch(placemarkProvider);

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 32),
          onPressed: () => context.pop(),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Current location", style: TextStyle(fontSize: 10)),
                placemarkAsync.when(
                  data:
                      (places) => Text(
                        places.isNotEmpty
                            ? places.first.street ?? "No street"
                            : "No address found",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                  loading: () => const Text("Loading..."),
                  error: (err, _) => Text("Error: $err"),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
