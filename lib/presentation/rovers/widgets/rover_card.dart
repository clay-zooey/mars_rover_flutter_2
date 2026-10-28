import 'package:flutter/material.dart';

import '../../../domain/models/mars_rover.dart';

class RoverCard extends StatelessWidget {
  const RoverCard({super.key, required this.rover, required this.onViewImages});

  final MarsRover rover;
  final VoidCallback onViewImages;

  String? get _banner => switch (rover.id) {
    'curiosity' => 'assets/images/curiousity_banner.png',
    'opportunity' => 'assets/images/opportunity_banner.png',
    'perseverance' => 'assets/images/perseverance_banner.png',
    'spirit' => 'assets/images/spirit_banner.png',
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.95,
            child: _banner == null
                ? ColoredBox(color: theme.colorScheme.surfaceContainerHighest)
                : Image.asset(
                    _banner!,
                    fit: BoxFit.cover,
                    semanticLabel: '${rover.name} Mars surface image',
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        rover.name,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onViewImages,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                        ),
                      ),
                      child: const Text('VIEW IMAGES'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _fact(context, 'Launch', rover.launchDate),
                _fact(context, 'Landing', rover.landingDate),
                _fact(context, 'Total Photos', '${rover.totalPhotos}'),
                _fact(context, 'Cameras Available', '${rover.cameras.length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fact(BuildContext context, String label, String value) => Text(
    '$label: $value',
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      height: 1.5,
    ),
  );
}
