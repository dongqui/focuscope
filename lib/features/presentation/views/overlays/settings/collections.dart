import 'package:flutter/material.dart';

class CollectionsOverlay extends StatefulWidget {
  const CollectionsOverlay({super.key});

  @override
  State<CollectionsOverlay> createState() => _CollectionsOverlayState();
}

class _CollectionsOverlayState extends State<CollectionsOverlay> {
  @override
  Widget build(BuildContext context) {
    return const Text('Collections',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
  }
}
