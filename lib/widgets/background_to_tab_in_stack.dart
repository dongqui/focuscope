import 'package:flutter/material.dart';

class BackgroundToTabInStack extends StatelessWidget {
  final VoidCallback onTap;

  const BackgroundToTabInStack({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
