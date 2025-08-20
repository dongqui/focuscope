import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/server_resource_info.dart';
import '../models/resource_version.dart';
import '../repositories/resource_version_repository.dart';
import '../repositories/character_repository.dart';
import '../repositories/planet_repository.dart';
import '../models/character.dart';
import '../models/planet.dart';

class ResourceUpdateService {
  static final ResourceUpdateService _instance =
      ResourceUpdateService._internal();
  static ResourceUpdateService get instance => _instance;

  ResourceUpdateService._internal();

  // 서버 API 엔드포인트 (실제 서버 URL로 변경 필요)
  static const String _baseUrl = 'https://your-api-server.com/api';

  // 리소스 타입별 엔드포인트
  static const String _characterEndpoint = '/resources/characters';
  static const String _planetEndpoint = '/resources/planets';

  /// 서버에서 리소스 정보를 가져옵니다
  Future<ServerResourceInfo?> fetchServerResourceInfo(
      String resourceType) async {
    try {
      final endpoint =
          resourceType == 'character' ? _characterEndpoint : _planetEndpoint;
      final response = await http.get(Uri.parse('$_baseUrl$endpoint'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ServerResourceInfo.fromJson(jsonData);
      }
    } catch (e) {
      print('서버에서 리소스 정보를 가져오는 중 오류 발생: $e');
    }
    return null;
  }

  /// 현재 로컬 버전과 서버 버전을 비교합니다
  Future<bool> needsUpdate(String resourceType) async {
    try {
      // 로컬 버전 정보 조회
      final localVersion = await ResourceVersionRepository.instance
          .getResourceVersion(resourceType);

      // 서버에서 최신 버전 정보 가져오기
      final serverInfo = await fetchServerResourceInfo(resourceType);

      if (serverInfo == null) return false;

      // 로컬 버전이 없거나 서버 버전이 더 최신인 경우 업데이트 필요
      if (localVersion == null) return true;

      return localVersion.version != serverInfo.version;
    } catch (e) {
      print('버전 비교 중 오류 발생: $e');
      return false;
    }
  }

  /// 이미지를 다운로드합니다
  Future<String?> downloadImage(String imageUrl, String fileName) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final appDir = await getApplicationDocumentsDirectory();
        final assetsDir = Directory(path.join(appDir.path, 'assets', 'images'));

        // 디렉토리가 없으면 생성
        if (!await assetsDir.exists()) {
          await assetsDir.create(recursive: true);
        }

        final filePath = path.join(assetsDir.path, fileName);
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      }
    } catch (e) {
      print('이미지 다운로드 중 오류 발생: $e');
    }
    return null;
  }

  /// 캐릭터 리소스를 업데이트합니다
  Future<bool> updateCharacterResources() async {
    try {
      final serverInfo = await fetchServerResourceInfo('character');
      if (serverInfo == null) return false;

      // 각 캐릭터의 이미지 다운로드
      for (final item in serverInfo.items) {
        final imagePath =
            await downloadImage(item.imageUrl, 'characters/${item.name}.png');

        if (imagePath != null) {
          // 캐릭터 데이터를 DB에 저장/업데이트
          final character = Character(
            id: item.id,
            name: item.name,
            travelframes: item.additionalData['travelframes'] ?? [0],
            travelSprite: 'characters/${item.name}_travel.png',
            idleSprite: 'characters/${item.name}_idle.png',
            idleFrames: item.additionalData['idleFrames'] ?? [0],
            isPremium: item.isPremium,
          );

          await CharacterRepository.instance.updateCharacter(character);
        }
      }

      // 버전 정보 업데이트
      final version = ResourceVersion(
        resourceType: 'character',
        version: serverInfo.version,
        lastUpdated: serverInfo.lastUpdated,
        isDownloaded: true,
      );
      await ResourceVersionRepository.instance.saveResourceVersion(version);

      return true;
    } catch (e) {
      print('캐릭터 리소스 업데이트 중 오류 발생: $e');
      return false;
    }
  }

  /// 행성 리소스를 업데이트합니다
  Future<bool> updatePlanetResources() async {
    try {
      final serverInfo = await fetchServerResourceInfo('planet');
      if (serverInfo == null) return false;

      // 각 행성의 이미지 다운로드
      for (final item in serverInfo.items) {
        final imagePath =
            await downloadImage(item.imageUrl, 'planets/${item.name}.png');

        if (imagePath != null) {
          // 행성 데이터를 DB에 저장/업데이트
          final planet = Planet(
            id: item.id,
            name: item.name,
            url: 'planets/${item.name}.png',
            isPremium: item.isPremium,
          );

          await PlanetRepository.instance.updatePlanet(planet);
        }
      }

      // 버전 정보 업데이트
      final version = ResourceVersion(
        resourceType: 'planet',
        version: serverInfo.version,
        lastUpdated: serverInfo.lastUpdated,
        isDownloaded: true,
      );
      await ResourceVersionRepository.instance.saveResourceVersion(version);

      return true;
    } catch (e) {
      print('행성 리소스 업데이트 중 오류 발생: $e');
      return false;
    }
  }

  /// 업데이트가 필요한 리소스 타입들을 확인합니다
  Future<List<String>> checkForUpdates() async {
    final List<String> needsUpdateList = [];

    if (await needsUpdate('character')) {
      needsUpdateList.add('character');
    }

    if (await needsUpdate('planet')) {
      needsUpdateList.add('planet');
    }

    return needsUpdateList;
  }

  /// 특정 리소스 타입을 업데이트합니다
  Future<bool> updateResourceType(String resourceType) async {
    switch (resourceType) {
      case 'character':
        return await updateCharacterResources();
      case 'planet':
        return await updatePlanetResources();
      default:
        return false;
    }
  }
}
