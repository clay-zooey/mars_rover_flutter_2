import 'package:flutter/material.dart';

class StatusContent extends StatelessWidget {
  const StatusContent({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 20),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ],
    ),
  );
}
