import 'package:flutter/material.dart';
import 'package:catodo/features/presentation/viewmodels/discovery_state.dart';
import 'package:catodo/features/data/models/planet.dart';

class Discoveries extends StatefulWidget {
  const Discoveries({super.key});

  @override
  State<Discoveries> createState() => _DiscoveriesState();
}

class _DiscoveriesState extends State<Discoveries> {
  final List<Planet> _planets = [
    // 임시 데이터 추가
    Planet(
      id: 1,
      name: '테스트 행성',
      url: 'assets/images/planets/premium/p_planet_1.gif',
      isPremium: false,
    ),
    Planet(
      id: 2,
      name: '테스트 행성',
      url: 'assets/images/planets/premium/p_planet_2.gif',
      isPremium: false,
    ),
    Planet(
      id: 3,
      name: '테스트 행성',
      url: 'assets/images/planets/premium/p_planet_3.gif',
      isPremium: false,
    ),
  ]; // 초기값 할당

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
        // _planets = state.planets;
      });
    }
  }

  Future<void> _loadPlanets() async {
    await DiscoveryManager.instance.fetchFinishedPlanets();
    setState(() {
      // _planets = DiscoveryManager.instance.state.planets;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4열, 간격 16, lazy하게 빌드
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // 3열로 변경
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: _planets.length,
      itemBuilder: (context, index) {
        return GifCell(imageUrl: _planets[index].url);
      },
    );
  }
}

class GifCell extends StatefulWidget {
  final String imageUrl;
  const GifCell({super.key, required this.imageUrl});

  @override
  State<GifCell> createState() => _GifCellState();
}

class _GifCellState extends State<GifCell> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 180), // 3분에 한 바퀴
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(seconds: 2), // 2초에 한 번 위아래
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 360도
    ).animate(_rotationController);

    _bounceAnimation = Tween<double>(
      begin: -5, // 위로 20픽셀
      end: 5, // 아래로 20픽셀
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // 애니메이션 완료 후 reverse하도록 리스너 추가
    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _bounceController.forward();
      }
    });

    _rotationController.repeat(); // 무한 반복
    _bounceController.forward(); // 바운스 애니메이션 시작
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Image.asset(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
