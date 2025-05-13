import 'package:flutter/material.dart';

class FullScreenOverlay extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onClose;

  const FullScreenOverlay({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // Stack 안에 있는지 확인
    assert(
      context.findAncestorWidgetOfExactType<Stack>() != null,
      'FullScreenOverlay must be used inside a Stack.',
    );

    return Positioned.fill(
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Stack(
            children: [
              // 실제 콘텐츠
              Positioned.fill(child: child),

              // 좌측 상단 닫기 버튼
              if (onClose != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: Icon(Icons.close, size: 28, color: Color(0xFFFFFFFF)),
                    onPressed: onClose,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
