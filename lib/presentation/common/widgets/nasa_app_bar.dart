import 'package:flutter/material.dart';

class NasaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NasaAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) => AppBar(
    centerTitle: true,
    toolbarHeight: 64,
    elevation: 4,
    scrolledUnderElevation: 4,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black26,
    backgroundColor: Theme.of(context).colorScheme.surface,
    title: Image.asset(
      'assets/images/nasa_logo.png',
      height: 36,
      fit: BoxFit.contain,
      semanticLabel: 'NASA',
    ),
  );
}
