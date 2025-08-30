import 'dart:io';
import 'dart:convert'; // Added for json.decode
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:catodo/core/utils/date_helper.dart';
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
  final int version;
  final List<Resource> resources;

  VersionWithResources({
    required this.version,
    required this.resources,
  });

  factory VersionWithResources.fromJson(Map<String, dynamic> json) {
    return VersionWithResources(
      version: json['version'] as int,
      resources: List<Resource>.from(json['resources'] as List),
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
    print()
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      return VersionWithResources.fromJson(jsonData);
    } else {
      return null;
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
}
