import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart'; // Flame 초기화를 위해 추가
import 'game/catodo_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen(); // 전체 화면 모드
  await Flame.device.setLandscape(); // 가로 모드 강제

  final game = CatodoGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget(
        game: game,
      ),
    ),
  );
}
