import 'package:catodo/core/db.dart';
import 'package:audioplayers/audioplayers.dart';

Future<void> init() async {
  await Future.wait([
    DatabaseService.instance.setUpDB(),
  ]);
}
