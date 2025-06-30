import 'package:catodo/core/observer.dart';
import 'package:catodo/features/data/models/discovery.dart';
import 'package:catodo/features/data/models/focus_session_model.dart';
import 'package:catodo/features/data/repositories/discovery_repository.dart';
import 'package:catodo/features/data/repositories/focus_session_repository.dart';

class DiscoveryState {
  final Discovery? currentDiscovery;
  final List<FocusSession> sessions;

  DiscoveryState({
    required this.currentDiscovery,
    required this.sessions,
  });

  DiscoveryState copyWith({
    Discovery? currentDiscovery,
    List<FocusSession>? sessions,
  }) {
    return DiscoveryState(
      currentDiscovery: currentDiscovery ?? this.currentDiscovery,
      sessions: sessions ?? this.sessions,
    );
  }
}

class DiscoveryManager extends Observer<DiscoveryState> {
  static final DiscoveryManager _instance = DiscoveryManager._internal();
  static DiscoveryManager get instance => _instance;

  DiscoveryState _state;

  DiscoveryManager._internal()
      : _state = DiscoveryState(
          currentDiscovery: null,
          sessions: [],
        );

  DiscoveryState get state => _state;

  void _updateState(DiscoveryState state) {
    _state = state;
    notifyListeners(state);
  }

  Future<void> initializeCurrentDiscovery() async {
    // 1. currentDiscovery 초기화
    final discovery =
        await DiscoveryRepository.instance.getOrCreateActiveDiscovery();

    // 2. 세션 리스트 초기화
    List<FocusSession> sessions = [];
    if (discovery.sessionIds.isNotEmpty) {
      sessions = await FocusSessionRepository.instance
          .getFocusSessionsByIds(discovery.sessionIds);
    }

    // 상태 업데이트
    _updateState(_state.copyWith(
      currentDiscovery: discovery,
      sessions: sessions,
    ));
  }

  Future<void> finishCurrentDiscovery() async {
    if (_state.currentDiscovery != null) {
      await DiscoveryRepository.instance
          .finishDiscovery(_state.currentDiscovery!.id);
    }
  }
}
