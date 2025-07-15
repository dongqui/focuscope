import 'package:flutter/material.dart';

import 'package:catodo/features/presentation/viewmodels/characater_state.dart';
import 'package:flame/widgets.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:catodo/features/presentation/views/character_selectors.dart';

class CharacterSettingOverlay extends StatefulWidget {
  const CharacterSettingOverlay({super.key});

  @override
  State<CharacterSettingOverlay> createState() =>
      _CharacterSettingOverlayState();
}

class _CharacterSettingOverlayState extends State<CharacterSettingOverlay>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _characterManager = CharacterManager.instance;
  late CharacterState _characterState;
  SpriteAnimation? _characterIdleAnimation;

  void _handleCharacterStateChanged(
      CharacterState state, CharacterState? oldState) {
    setState(() {
      _characterState = state;
    });

    if (state.selectedCharacter != null &&
        state.selectedCharacter?.name != oldState?.selectedCharacter?.name) {
      loadAnimation();
    }
  }

  initData() async {
    await Future.wait([
      _characterManager.initSelectedCharacter(),
    ]);

    await loadAnimation();
    setState(() {});
  }

  loadAnimation() async {
    final sprites =
        await Flame.images.load(_characterState.selectedCharacter!.idleSprite);
    final frames = _characterState.selectedCharacter!.idleFrames
        .map((index) => Sprite(
              sprites,
              srcSize: Vector2(256, 256),
              srcPosition: Vector2(index * 256, 0),
            ))
        .toList();

    _characterIdleAnimation = SpriteAnimation.spriteList(frames, stepTime: 0.2);
  }

  @override
  void didUpdateWidget(covariant CharacterSettingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    initData();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _characterState = _characterManager.state;
    _characterManager.addListener(_handleCharacterStateChanged);

    initData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _characterManager.removeListener(_handleCharacterStateChanged);
    super.dispose();
  }

  openCharacterSelectors() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: CharacterSelectors(
            onClose: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _characterIdleAnimation != null
        ? Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: openCharacterSelectors,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 128,
                  height: 128,
                  child: SpriteAnimationWidget(
                    animation: _characterIdleAnimation!,
                    animationTicker:
                        SpriteAnimationTicker(_characterIdleAnimation!),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(1.0, 1.0), // 아래쪽
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8), // 아래 여백
                  child: RawMaterialButton(
                    onPressed: openCharacterSelectors,
                    elevation: 4.0,
                    fillColor: Color(0xFF171F2A),
                    shape: const CircleBorder(),
                    constraints: const BoxConstraints.tightFor(
                      width: 40,
                      height: 40,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
