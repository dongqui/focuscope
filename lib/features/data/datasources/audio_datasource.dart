import 'package:catodo/core/storage/document_store.dart';
import 'package:catodo/features/data/models/audio_model.dart';

class AudioDataSource {
  final DocumentStore<Audio> _store;

  AudioDataSource(this._store);

  /// 오디오 설정은 항상 한 벌만 존재한다. 없으면 기본값으로 만들어 준다.
  Future<Audio> getOrCreateAudio() async {
    final existing = _store.query();
    if (existing.isNotEmpty) {
      return existing.first;
    }
    final newAudio = Audio(
      whiteNoise: [],
      currentMusic: '',
      isMusicOn: true,
    );
    await _store.add(newAudio);
    return newAudio;
  }

  Future<void> updateAudio(Audio audio) async {
    final existing = _store.query();
    if (existing.isEmpty) {
      await _store.add(audio);
      return;
    }
    await _store.put(existing.first.id!, audio);
  }
}
