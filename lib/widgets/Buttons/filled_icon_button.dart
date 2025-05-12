import 'package:flutter/material.dart';

class FilledIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;

  const FilledIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF4c90de),
    this.iconColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: IconButton(
        color: iconColor,
        onPressed: onPressed,
        icon: Icon(
          icon,
        ),
      ),
    );
  }
}
