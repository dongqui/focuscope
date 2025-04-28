import 'package:just_audio/just_audio.dart';

enum AudioType {
  rain,
  birds,
}

class AudioController {
  final Map<AudioType, AudioPlayer?> audioPlayers = {
    AudioType.rain: AudioPlayer(),
    AudioType.birds: AudioPlayer(),
  };

  play(AudioType type) async {
    final player = audioPlayers[type];
    await player?.setAsset('assets/sounds/${type.name}.mp3');
    player?.play();
  }

  stop(AudioType type) async {
    final player = audioPlayers[type];
    player?.pause();
  }

  dispose() {
    for (var player in audioPlayers.values) {
      player?.dispose();
    }
  }
}
