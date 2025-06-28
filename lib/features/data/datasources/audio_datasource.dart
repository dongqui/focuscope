import 'package:isar/isar.dart';
import 'package:catodo/features/data/models/audio_model.dart';

class AudioDataSource {
  final Isar _isar;

  AudioDataSource(this._isar);

  Future<void> getAudio(Audio audio) async {
    await _isar.writeTxn(() async {});
  }

  Future<Audio> getOrCreateAudio() async {
    final audio = await _isar.audios.where().findFirst();
    if (audio != null) {
      return audio;
    } else {
      final newAudio = Audio(
        whiteNoise: [],
        currentMusic: '',
        isMusicOn: true,
      );
      await _isar.writeTxn(() async {
        await _isar.audios.put(newAudio);
      });
      return newAudio;
    }
  }

  Future<void> updateAudio(Audio audio) async {
    await _isar.writeTxn(() async {
      final existingAudio = await _isar.audios.where().findFirst();
      if (existingAudio != null) {
        audio.id = existingAudio.id;
        await _isar.audios.put(audio);
      }
    });
  }
}
