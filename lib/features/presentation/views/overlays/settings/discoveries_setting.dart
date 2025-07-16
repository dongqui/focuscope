import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/discovery_state.dart';
import 'package:catodo/features/data/models/planet.dart';
import 'package:flame/widgets.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:catodo/features/presentation/views/discoveries.dart';

class DiscoveriesSetting extends StatefulWidget {
  const DiscoveriesSetting({super.key});

  @override
  State<DiscoveriesSetting> createState() => _DiscoveriesSettingState();
}

class _DiscoveriesSettingState extends State<DiscoveriesSetting> {
  List<SpriteAnimation> _planetAnimations = [];

  @override
  void initState() {
    super.initState();
    DiscoveryManager.instance.addListener(_onDiscoveryStateChanged);
    _loadPlanets();
  }

  @override
  void dispose() {
    DiscoveryManager.instance.removeListener(_onDiscoveryStateChanged);
    super.dispose();
  }

  void _onDiscoveryStateChanged(
      DiscoveryState state, DiscoveryState? oldState) async {
    if (state.planets.length != oldState?.planets.length) {
      await _loadPlanetAnimations(state.planets);
    }
    setState(() {});
  }

  Future<void> _loadPlanets() async {
    await DiscoveryManager.instance.fetchFinishedPlanets();
    await _loadPlanetAnimations(DiscoveryManager.instance.state.planets);
    // 상태 변경은 리스너에서 처리하므로 여기서는 setState 불필요
  }

  Future<void> _loadPlanetAnimations(List<Planet> planets) async {
    _planetAnimations = await Future.wait(planets.take(4).map((planet) async {
      final image = await Flame.images.load(planet.sprite);
      final frames = planet.frames
          .map((index) => Sprite(
                image,
                srcSize: Vector2(1024, 1024),
                srcPosition: Vector2(index * 1024, 0),
              ))
          .toList();
      return SpriteAnimation.spriteList(frames, stepTime: 0.2);
    }));
  }

  showDiscoveries() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Discoveries(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showDiscoveries,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 128,
            child: Stack(
              children: [
                ..._planetAnimations.asMap().entries.map((entry) {
                  final i = entry.key;
                  final animation = entry.value;
                  return Positioned(
                    left: i * 50.0,
                    top: 0,
                    child: SizedBox(
                      width: 128,
                      height: 128,
                      child: SpriteAnimationWidget(
                        animation: animation,
                        animationTicker: SpriteAnimationTicker(animation),
                      ),
                    ),
                  );
                }),
                if (DiscoveryManager.instance.state.planets.length > 4)
                  Positioned(
                    left: 5 * 50.0 + 15, // 마지막 행성 오른쪽
                    top: 48, // 행성 중앙쯤
                    child: Text(
                      '...',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.white,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('찾은 행성:  ${DiscoveryManager.instance.state.planets.length}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(width: 16),
              Text('See more',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF3A86FF))),
            ],
          ),
        ],
      ),
    );
  }
}
