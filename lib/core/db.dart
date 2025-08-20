import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:catodo/features/data/models/focus_session_model.dart';
import 'package:catodo/features/data/models/latest-activity-model.dart';
import 'package:catodo/features/data/datasources/focus_session_datasource.dart';
import 'package:catodo/features/data/datasources/latest-activity-datasource.dart';
import 'package:catodo/features/data/repositories/focus_session_repository.dart';
import 'package:catodo/features/data/repositories/latest_activity_repository.dart';
import 'package:catodo/features/data/datasources/audio_datasource.dart';
import 'package:catodo/features/data/repositories/audio_repository.dart';
import 'package:catodo/features/data/models/audio_model.dart';
import 'package:catodo/features/data/datasources/chacater-datasource.dart';
import 'package:catodo/features/data/repositories/character_repository.dart';
import 'package:catodo/features/data/datasources/selected_character_datasource.dart';
import 'package:catodo/features/data/repositories/selected_character_repository.dart';
import 'package:catodo/features/data/models/character.dart';
import 'package:catodo/features/data/models/selected_character.dart';
import 'package:catodo/features/data/datasources/discovery_datasource.dart';
import 'package:catodo/features/data/repositories/discovery_repository.dart';
import 'package:catodo/features/data/models/discovery.dart';
import 'package:catodo/features/data/models/planet.dart';
import 'package:catodo/features/data/datasources/planet_datasource.dart';
import 'package:catodo/features/data/repositories/planet_repository.dart';
import 'package:catodo/features/data/models/resource_version.dart';
import 'package:catodo/features/data/datasources/resource_version_datasource.dart';
import 'package:catodo/features/data/repositories/resource_version_repository.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;
  DatabaseService._internal();

  Isar? _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      _isar = await Isar.open(
        [
          FocusSessionSchema,
          LatestActivitySchema,
          AudioSchema,
          CharacterSchema,
          SelectedCharacterSchema,
          DiscoverySchema,
          PlanetSchema,
          ResourceVersionSchema,
        ],
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
    final characterDataSource = CharacterDataSource(isar);
    final selectedCharacterDataSource = SelectedCharacterDataSource(isar);
    final discoveryDataSource = DiscoveryDataSource(isar);
    final planetDataSource = PlanetDataSource(isar);
    final resourceVersionDataSource = ResourceVersionDataSource(isar);

    // repository
    FocusSessionRepository.initialize(focusSessionDataSource);
    LatestActivityRepository.initialize(latestActivityDataSource);
    AudioRepository.initialize(audioDataSource);
    CharacterRepository.initialize(characterDataSource);
    SelectedCharacterRepository.initialize(selectedCharacterDataSource);
    DiscoveryRepository.initialize(discoveryDataSource);
    PlanetRepository.initialize(planetDataSource);
    ResourceVersionRepository.initialize(resourceVersionDataSource);
  }
}
