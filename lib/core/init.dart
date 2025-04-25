import 'package:catodo/core/db.dart';

Future<void> init() async {
  await Future.wait([
    DatabaseService.instance.setUpDB(),
  ]);
}
