import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/discovery_state.dart';
import 'package:catodo/features/data/models/planet.dart';
import 'package:flame/widgets.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';

class Discoveries extends StatefulWidget {
  const Discoveries({super.key});

  @override
  State<Discoveries> createState() => _DiscoveriesState();
}

class _DiscoveriesState extends State<Discoveries> {
  List<Planet> _planets = []; // 초기값 할당

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
      DiscoveryState state, DiscoveryState? oldState) {
    if (state.planets.length != oldState?.planets.length) {
      setState(() {
        _planets = state.planets;
      });
    }
  }

  Future<void> _loadPlanets() async {
    await DiscoveryManager.instance.fetchFinishedPlanets();
    setState(() {
      _planets = DiscoveryManager.instance.state.planets;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4열, 간격 16, lazy하게 빌드
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3열로 변경
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: _planets.length,
      itemBuilder: (context, index) {
        return PlanetAnimationCell(planet: _planets[index]);
      },
    );
  }
}

class PlanetAnimationCell extends StatefulWidget {
  final Planet planet;
  const PlanetAnimationCell({required this.planet, super.key});

  @override
  State<PlanetAnimationCell> createState() => _PlanetAnimationCellState();
}

class _PlanetAnimationCellState extends State<PlanetAnimationCell> {
  SpriteAnimation? _animation;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAnimationIfNeeded();
  }

  Future<void> _loadAnimationIfNeeded() async {
    if (_animation != null || _loading) return;
    setState(() => _loading = true);

    final image = await Flame.images.load(widget.planet.sprite);
    final frames = widget.planet.frames
        .map((index) => Sprite(
              image,
              srcSize: Vector2(1024, 1024),
              srcPosition: Vector2(index * 1024, 0),
            ))
        .toList();
    final animation = SpriteAnimation.spriteList(frames, stepTime: 0.2);

    if (mounted) {
      setState(() {
        _animation = animation;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_animation != null) {
      return SpriteAnimationWidget(
        animation: _animation!,
        animationTicker: SpriteAnimationTicker(_animation!),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}
