import 'package:flutter/material.dart';

import '../../../domain/models/mars_photo.dart';

class PhotoTile extends StatelessWidget {
  const PhotoTile({super.key, required this.photo});

  final MarsPhoto photo;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Image.network(
      photo.imageUrl,
      fit: BoxFit.cover,
      semanticLabel: 'Mars rover photo',
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).colorScheme.onErrorContainer,
            semanticLabel: 'Failed to load photo',
          ),
        ),
      ),
    ),
  );
}
