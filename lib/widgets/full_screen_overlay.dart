import 'package:flutter/material.dart';

class FullScreenOverlay extends StatefulWidget {
  final Widget Function(BuildContext, VoidCallback?) child;
  final Color backgroundColor;
  final VoidCallback onClose;

  const FullScreenOverlay({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    required this.onClose,
  });

  @override
  State<FullScreenOverlay> createState() => _FullScreenOverlayState();
}

class _FullScreenOverlayState extends State<FullScreenOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _fadeAnimation = curve;
    _scaleAnimation = Tween<double>(begin: 1.05, end: 1.0).animate(curve);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() async {
    if (_isClosing) return;
    setState(() => _isClosing = true);
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      context.findAncestorWidgetOfExactType<Stack>() != null,
      'FullScreenOverlay must be used inside a Stack.',
    );

    return Positioned.fill(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            color: widget.backgroundColor,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(child: widget.child(context, _handleClose)),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon:
                          Icon(Icons.close, size: 28, color: Color(0xFFFFFFFF)),
                      onPressed: _handleClose,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
