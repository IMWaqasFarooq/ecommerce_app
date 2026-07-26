import 'package:flutter/material.dart';

import 'core/config/flavor.dart';

class VeloraApp extends StatelessWidget {
  const VeloraApp({super.key, required this.flavor});

  final Flavor flavor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1A1A2E)),
      home: Scaffold(
        body: Center(child: Text('Velora (${flavor.name})')),
      ),
    );
  }
}
