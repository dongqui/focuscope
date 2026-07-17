import 'dart:io';
import 'dart:convert'; // Added for json.decode
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:catodo/core/utils/date_helper.dart';
import 'package:catodo/core/utils/path_helper.dart';
import 'package:catodo/features/data/models/resource.dart';
// 버전별 리소스 응답 모델 (ServerResourceVersionDataSource에서 정의된 것과 동일)

class Response<T> {
  final bool success;
  final T? data;

  Response({required this.success, required this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      success: json['success'],
      data: json['data'],
    );
  }
}

class Version {
  final DateTime createdAt;
  final int version;

  Version({required this.createdAt, required this.version});

  factory Version.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;

    createdAt = DateHelper.parseFirestoreTimestamp(json['createdAt'])!;

    return Version(
      createdAt: createdAt,
      version: json['version'] as int,
    );
  }
}

class VersionWithResources {
  final Version version;
  final List<Resource> resources;

  VersionWithResources({
    required this.version,
    required this.resources,
  });

  factory VersionWithResources.fromJson(Map<String, dynamic> json) {
    return VersionWithResources(
      version: Version(
        createdAt:
            DateHelper.parseFirestoreTimestamp((json['version']['createdAt']))!,
        version: json['version']['version'],
      ),
      resources: (json['resources'] as List)
          .map((resourceJson) =>
              Resource.fromJson(resourceJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ResourceUpdateService {
  static final ResourceUpdateService _instance =
      ResourceUpdateService._internal();
  static ResourceUpdateService get instance => _instance;

  ResourceUpdateService._internal();

  // 서버 API 엔드포인트 (실제 서버 URL로 변경 필요)
  static final String _baseUrl = dotenv.env['API_BASE_URL']!;

  /// 서버에서 리소스 정보를 가져옵니다
  Future<Version?> fetchServerResourceInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/getResourceVersion'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        return Version.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<VersionWithResources?> fetchResourcesBetweenVersions(
      int currentVersion) async {
    final response = await http.get(
        Uri.parse(
            '$_baseUrl/getResourcesBetweenVersions?version=$currentVersion'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      print('Response data: $jsonData');

      // 데이터 구조 확인
      if (jsonData.containsKey('resources')) {
        // resources만 있는 경우 임시 버전 정보로 생성
        final resources = (jsonData['resources'] as List)
            .map((resourceJson) =>
                Resource.fromJson(resourceJson as Map<String, dynamic>))
            .toList();

        return VersionWithResources(
          version: Version(
            createdAt: DateTime.now(),
            version: currentVersion + 1,
          ),
          resources: resources,
        );
      } else {
        // 기존 구조인 경우
        return VersionWithResources.fromJson(jsonData);
      }
    } else {
      return null;
    }
  }

  /// 이미지를 다운로드합니다
  Future<String?> downloadImage({
    required String imageUrl,
    required String subPath,
    required String fileName,
  }) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final filePath = await PathHelper.getAssetsImagePath(
            imageUrl: imageUrl, subPath: subPath, fileName: fileName);

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      }
    } catch (e) {
      print('이미지 다운로드 중 오류 발생: $e');
    }
    return null;
  }

  /// 다운로드된 이미지 파일의 경로를 가져옵니다
  Future<String?> getImagePath(String fileName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final assetsDir = Directory(path.join(appDir.path, 'assets', 'images'));

      // 파일이 존재하는지 확인
      final filePath = path.join(assetsDir.path, fileName);
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      // 확장자가 없는 경우 .gif, .png, .jpg 순서로 확인
      final extensions = ['.gif', '.png', '.jpg', '.jpeg'];
      for (final extension in extensions) {
        final fileWithExt = File('$filePath$extension');
        if (await fileWithExt.exists()) {
          return fileWithExt.path;
        }
      }

      return null;
    } catch (e) {
      print('이미지 경로 가져오기 중 오류 발생: $e');
      return null;
    }
  }
}
