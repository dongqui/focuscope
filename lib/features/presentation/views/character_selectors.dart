import 'package:catodo/features/presentation/viewmodels/characater_state.dart';
import 'package:flutter/material.dart';
import 'package:flame/widgets.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';

class CharacterSelectors extends StatefulWidget {
  final VoidCallback onClose;
  const CharacterSelectors({super.key, required this.onClose});

  @override
  State<CharacterSelectors> createState() => _CharacterSelectorsState();
}

class _CharacterSelectorsState extends State<CharacterSelectors> {
  late CharacterState _characterState;
  final _characterManager = CharacterManager.instance;
  late List<SpriteAnimation> _characterTravelAnimations = [];
  late List<SpriteAnimation> _characterIdleAnimations = [];
  late String _selectedCharacterName = '';
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _characterState = _characterManager.state;
    _characterManager.addListener(_handleCharacterStateChanged);

    initData();
  }

  @override
  void dispose() {
    _characterManager.removeListener(_handleCharacterStateChanged);
    super.dispose();
  }

  void _handleCharacterStateChanged(CharacterState state) {
    setState(() {
      _characterState = state;
    });
  }

  initData() async {
    await Future.wait([
      _characterManager.initSelectedCharacter(),
      _characterManager.getCharacterList(),
    ]);
    // 선택된 케릭터 이름 초기화
    _selectedCharacterName = _characterState.selectedCharacter?.name ?? '';

    // init pageView page
    final selectedIndex = _characterState.characterList.indexWhere(
      (c) => c.name == _selectedCharacterName,
    );

    //선택된 케릭터로 페이지 초기화
    _pageController =
        PageController(viewportFraction: 0.4, initialPage: selectedIndex);

// 애니메이션 생성
    _characterTravelAnimations =
        await Future.wait(_characterState.characterList.map((character) async {
      final sprites = await Flame.images.load(character.travelSprite);

      final frames = character.travelframes
          .map((index) => Sprite(
                sprites,
                srcSize: Vector2(256, 256),
                srcPosition: Vector2(index * 256, 0),
              ))
          .toList();
      return SpriteAnimation.spriteList(
        frames,
        stepTime: 0.2,
      );
    }));
    _characterIdleAnimations =
        await Future.wait(_characterState.characterList.map((character) async {
      final sprites = await Flame.images.load(character.idleSprite);
      final frames = character.idleFrames
          .map((index) => Sprite(
                sprites,
                srcSize: Vector2(256, 256),
                srcPosition: Vector2(index * 256, 0),
              ))
          .toList();
      return SpriteAnimation.spriteList(frames, stepTime: 0.2);
    }));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_characterState.characterList.isEmpty ||
        _characterTravelAnimations.isEmpty ||
        _characterIdleAnimations.isEmpty) {
      return const Center(child: Text(''));
    }
    return Stack(
      children: [
        SizedBox(
          child: PageView.builder(
            itemCount: _characterState.characterList.length,
            controller: _pageController,
            onPageChanged: (index) {
              _selectedCharacterName =
                  _characterState.characterList[index].name;
              setState(() {});
            },
            itemBuilder: (context, index) {
              final character = _characterState.characterList[index];
              final isSelected = _selectedCharacterName == character.name;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(
                    horizontal: 8, vertical: isSelected ? 0 : 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCharacterName = character.name;
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: isSelected ? 128 : 64,
                        height: isSelected ? 128 : 64,
                        child: isSelected
                            ? SpriteAnimationWidget(
                                animation: _characterTravelAnimations[index],
                                animationTicker: SpriteAnimationTicker(
                                    _characterTravelAnimations[index]),
                              )
                            : SpriteAnimationWidget(
                                animation: _characterIdleAnimations[index],
                                animationTicker: SpriteAnimationTicker(
                                    _characterIdleAnimations[index])),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.25,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  await _characterManager.updateCharacter(
                      _characterState.characterList.firstWhere((character) =>
                          character.name == _selectedCharacterName));
                  widget.onClose();
                },
                child: const Text('너로 정했다!'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
