import '../datasources/audio_datasource.dart';
import '../models/audio_model.dart';

class AudioRepository {
  final AudioDataSource dataSource;

  // 싱글톤 인스턴스를 저장할 정적 변수
  static AudioRepository? _instance;

  // 외부에서 데이터 소스를 주입받는 생성자
  AudioRepository._internal(this.dataSource);

  // 싱글톤 인스턴스를 반환하는 정적 getter
  static AudioRepository get instance {
    if (_instance == null) {
      throw Exception(
          "AudioRepository is not initialized. Call initialize() first.");
    }
    return _instance!;
  }

  // 초기화 메서드
  static void initialize(AudioDataSource dataSource) {
    _instance ??= AudioRepository._internal(dataSource);
  }

  // Audio 저장
  Future<void> updateAudio(Audio audio) async {
    await dataSource.updateAudio(audio);
  }

  // Audio 불러오기
  Future<Audio> getOrCreateAudio() async {
    return await dataSource.getOrCreateAudio();
  }
}
