import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:catodo/shared_domain/focus_session/models/focus_session_model.dart';
import 'package:catodo/features/overlays/data/models/latest-activity-model.dart';
import 'package:catodo/shared_domain/focus_session/datasources/focus_session_datasource.dart';
import 'package:catodo/features/overlays/data/datasources/latest-activity-datasource.dart';
import 'package:catodo/shared_domain/focus_session/repositories/focus_session_repository.dart';
import 'package:catodo/features/overlays/data/repositories/latest_activity_repository.dart';
import 'package:catodo/features/audio/data/datasources/audio_datasource.dart';
import 'package:catodo/features/audio/data/repositories/audio_repository.dart';
import 'package:catodo/features/audio/data/models/audio_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;
  DatabaseService._internal();

  Isar? _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      _isar = await Isar.open(
        [FocusSessionSchema, LatestActivitySchema, AudioSchema],
        directory: dir.path,
      );
    } else {
      _isar = Isar.getInstance();
    }
  }

  Isar get isar => _isar!;

  Future<void> setUpDB() async {
    await DatabaseService.instance.init();

    final isar = DatabaseService.instance.isar;

    // datasource
    final focusSessionDataSource = FocusSessionDataSource(isar);
    final latestActivityDataSource = LatestActivityDataSource(isar);
    final audioDataSource = AudioDataSource(isar);

    // repository
    FocusSessionRepository.initialize(focusSessionDataSource);
    LatestActivityRepository.initialize(latestActivityDataSource);
    AudioRepository.initialize(audioDataSource);
  }
}
