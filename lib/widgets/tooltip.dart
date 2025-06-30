import 'package:flutter/material.dart';

class Tooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final bool show;
  final VoidCallback? onClose;

  const Tooltip({
    super.key,
    required this.child,
    required this.message,
    required this.show,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        child,
        if (show)
          Positioned(
            top: -40,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
