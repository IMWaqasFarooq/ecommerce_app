import 'package:flutter/material.dart';

class CartPlaceholderPage extends StatelessWidget {
  const CartPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: const Center(child: Text('Cart is coming in Phase 4')),
    );
  }
}
