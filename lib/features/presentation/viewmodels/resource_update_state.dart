import 'package:catodo/core/observer.dart';
import '../../data/services/resource_update_service.dart';

enum UpdateStatus {
  idle,
  checking,
  downloading,
  completed,
  error,
}

class ResourceUpdateState {
  final UpdateStatus status;
  final String message;
  final double progress;
  final bool hasUpdates;

  ResourceUpdateState({
    this.status = UpdateStatus.idle,
    this.message = '',
    this.progress = 0.0,
    this.hasUpdates = false,
  });

  ResourceUpdateState copyWith({
    UpdateStatus? status,
    String? message,
    double? progress,
    bool? hasUpdates,
  }) {
    return ResourceUpdateState(
      status: status ?? this.status,
      message: message ?? this.message,
      progress: progress ?? this.progress,
      hasUpdates: hasUpdates ?? this.hasUpdates,
    );
  }
}

class ResourceUpdateManager extends Observer<ResourceUpdateState> {
  static final ResourceUpdateManager _instance =
      ResourceUpdateManager._internal();
  static ResourceUpdateManager get instance => _instance;

  ResourceUpdateState _state;
  final ResourceUpdateService _service = ResourceUpdateService.instance;

  ResourceUpdateManager._internal() : _state = ResourceUpdateState();

  ResourceUpdateState get state => _state;

  void updateStatus(UpdateStatus status, {String message = ''}) {
    _updateState(_state.copyWith(
      status: status,
      message: message,
    ));
  }

  void updateProgress(double progress) {
    _updateState(_state.copyWith(
      progress: progress,
    ));
  }

  void setHasUpdates(bool hasUpdates) {
    _updateState(_state.copyWith(
      hasUpdates: hasUpdates,
    ));
  }

  void reset() {
    _updateState(ResourceUpdateState());
  }

  /// 모든 리소스를 업데이트합니다
  Future<void> updateAllResources() async {
    updateStatus(UpdateStatus.checking, message: '업데이트 확인 중...');

    try {
      // 업데이트가 필요한 리소스 타입들을 확인
      final needsUpdateList = await _service.checkForUpdates();

      if (needsUpdateList.isEmpty) {
        updateStatus(UpdateStatus.completed, message: '최신 버전입니다');
        setHasUpdates(false);
        return;
      }

      setHasUpdates(true);

      // 각 리소스 타입별로 업데이트 진행
      for (int i = 0; i < needsUpdateList.length; i++) {
        final resourceType = needsUpdateList[i];
        final progress = (i / needsUpdateList.length) * 100;

        updateProgress(progress);

        String message = '';
        switch (resourceType) {
          case 'character':
            message = '캐릭터 리소스 다운로드 중...';
            break;
          case 'planet':
            message = '행성 리소스 다운로드 중...';
            break;
        }

        updateStatus(UpdateStatus.downloading, message: message);

        final success = await _service.updateResourceType(resourceType);
        if (!success) {
          updateStatus(UpdateStatus.error, message: '$resourceType 업데이트 실패');
          return;
        }
      }

      updateProgress(100.0);
      updateStatus(UpdateStatus.completed, message: '업데이트 완료');
    } catch (e) {
      updateStatus(UpdateStatus.error, message: '업데이트 중 오류 발생: $e');
    }
  }

  /// 특정 리소스 타입을 업데이트합니다
  Future<void> updateResourceType(String resourceType) async {
    updateStatus(UpdateStatus.downloading, message: '$resourceType 업데이트 중...');

    try {
      final success = await _service.updateResourceType(resourceType);

      if (success) {
        updateStatus(UpdateStatus.completed, message: '$resourceType 업데이트 완료');
      } else {
        updateStatus(UpdateStatus.error, message: '$resourceType 업데이트 실패');
      }
    } catch (e) {
      updateStatus(UpdateStatus.error, message: '$resourceType 업데이트 중 오류: $e');
    }
  }

  /// 업데이트가 필요한지 확인합니다
  Future<void> checkForUpdates() async {
    updateStatus(UpdateStatus.checking, message: '업데이트 확인 중...');

    try {
      final needsUpdateList = await _service.checkForUpdates();
      final hasUpdates = needsUpdateList.isNotEmpty;

      setHasUpdates(hasUpdates);

      if (hasUpdates) {
        updateStatus(UpdateStatus.idle, message: '업데이트가 필요합니다');
      } else {
        updateStatus(UpdateStatus.completed, message: '최신 버전입니다');
      }
    } catch (e) {
      updateStatus(UpdateStatus.error, message: '업데이트 확인 중 오류: $e');
    }
  }

  void _updateState(ResourceUpdateState state) {
    _state = state;
    notifyListeners(state);
  }
}
