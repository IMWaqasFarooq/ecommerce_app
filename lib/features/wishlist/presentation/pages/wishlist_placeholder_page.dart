import 'package:flutter/material.dart';

class WishlistPlaceholderPage extends StatelessWidget {
  const WishlistPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: const Center(child: Text('Wishlist is coming in Phase 4')),
    );
  }
}
