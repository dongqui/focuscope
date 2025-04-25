import 'package:isar/isar.dart';

part 'audio_model.g.dart';

@Collection()
class Audio {
  Id id = Isar.autoIncrement;
  late List<String> whiteNoise;
  late String currentMusic;
  late bool isMusicOn;

  Audio({
    required this.whiteNoise,
    required this.currentMusic,
    required this.isMusicOn,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        whiteNoise: json['whiteNoise'],
        currentMusic: json['currentMusic'],
        isMusicOn: json['isMusicOn'],
      );

  Map<String, dynamic> toJson() => {
        'whiteNoise': whiteNoise,
        'currentMusic': currentMusic,
        'isMusicOn': isMusicOn,
      };
}
