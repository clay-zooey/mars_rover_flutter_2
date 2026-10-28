import 'package:flutter/material.dart';

import 'domain/usecases/get_mars_photos.dart';
import 'domain/usecases/get_mars_rovers.dart';
import 'presentation/rovers/rovers_screen.dart';
import 'presentation/theme/app_theme.dart';

class MarsRoverApp extends StatefulWidget {
  const MarsRoverApp({
    super.key,
    required this.getRovers,
    required this.getPhotos,
    this.onDispose,
  });

  final GetMarsRovers getRovers;
  final GetMarsPhotos getPhotos;
  final VoidCallback? onDispose;

  @override
  State<MarsRoverApp> createState() => _MarsRoverAppState();
}

class _MarsRoverAppState extends State<MarsRoverApp> {
  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mars Rover',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    home: RoversScreen(
      getRovers: widget.getRovers,
      getPhotos: widget.getPhotos,
    ),
  );
}
