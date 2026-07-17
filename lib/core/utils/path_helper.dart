import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// 경로 관련 유틸리티 함수들을 제공하는 클래스
class PathHelper {
  /// 애플리케이션 문서 디렉토리 내의 assets/images 경로를 생성하고 반환합니다.
  ///
  /// [subPath]가 제공되면 assets/images/{subPath} 경로를 생성합니다.
  /// 예: getAssetsImagesPath('characters') -> assets/images/characters
  ///
  /// 디렉토리가 존재하지 않으면 자동으로 생성합니다.
  static Future<Directory> getAssetsImagesPath([String? subPath]) async {
    final appDir = await getApplicationDocumentsDirectory();
    final assetsPath = subPath != null
        ? path.join(appDir.path, 'assets', 'images', subPath)
        : path.join(appDir.path, 'assets', 'images');

    final assetsDir = Directory(assetsPath);

    // 디렉토리가 없으면 생성
    if (!await assetsDir.exists()) {
      await assetsDir.create(recursive: true);
    }

    return assetsDir;
  }

  static Future<String> getAssetsImagePath({
    required String imageUrl,
    required String fileName,
    String? subPath,
  }) async {
    final assetsDir = await PathHelper.getAssetsImagesPath(subPath);

    String finalFileName = fileName;
    if (!fileName.contains('.')) {
      final urlPath = Uri.parse(imageUrl).path;
      final extension = path.extension(urlPath);
      if (extension.isNotEmpty) {
        finalFileName = '$fileName$extension';
      } else {
        // 확장자를 추출할 수 없는 경우 기본값 사용
        finalFileName = '$fileName.gif';
      }
    }
    return path.join(assetsDir.path, finalFileName);
  }

  /// 애플리케이션 문서 디렉토리 내의 assets/sounds 경로를 생성하고 반환합니다.
  static Future<Directory> getAssetsSoundsPath([String? subPath]) async {
    final appDir = await getApplicationDocumentsDirectory();
    final assetsPath = subPath != null
        ? path.join(appDir.path, 'assets', 'sounds', subPath)
        : path.join(appDir.path, 'assets', 'sounds');

    final assetsDir = Directory(assetsPath);

    // 디렉토리가 없으면 생성
    if (!await assetsDir.exists()) {
      await assetsDir.create(recursive: true);
    }

    return assetsDir;
  }

  /// 애플리케이션 문서 디렉토리 내의 assets/tiles 경로를 생성하고 반환합니다.
  static Future<Directory> getAssetsTilesPath([String? subPath]) async {
    final appDir = await getApplicationDocumentsDirectory();
    final assetsPath = subPath != null
        ? path.join(appDir.path, 'assets', 'tiles', subPath)
        : path.join(appDir.path, 'assets', 'tiles');

    final assetsDir = Directory(assetsPath);

    // 디렉토리가 없으면 생성
    if (!await assetsDir.exists()) {
      await assetsDir.create(recursive: true);
    }

    return assetsDir;
  }

  /// 애플리케이션 문서 디렉토리 내의 임의의 assets 하위 경로를 생성하고 반환합니다.
  static Future<Directory> getAssetsPath(String category,
      [String? subPath]) async {
    final appDir = await getApplicationDocumentsDirectory();
    final assetsPath = subPath != null
        ? path.join(appDir.path, 'assets', category, subPath)
        : path.join(appDir.path, 'assets', category);

    final assetsDir = Directory(assetsPath);

    // 디렉토리가 없으면 생성
    if (!await assetsDir.exists()) {
      await assetsDir.create(recursive: true);
    }

    return assetsDir;
  }
}
