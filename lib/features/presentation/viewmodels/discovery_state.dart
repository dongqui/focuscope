import 'package:catodo/core/observer.dart';
import 'package:catodo/features/data/models/discovery.dart';
import 'package:catodo/features/data/models/focus_session_model.dart';
import 'package:catodo/features/data/repositories/discovery_repository.dart';
import 'package:catodo/features/data/repositories/focus_session_repository.dart';
import 'package:catodo/features/data/models/planet.dart';
import 'package:catodo/features/data/repositories/planet_repository.dart';

class DiscoveryState {
  final Discovery? currentDiscovery;
  final List<FocusSession> sessions;
  final Planet? planet;

  DiscoveryState({
    required this.currentDiscovery,
    required this.sessions,
    required this.planet,
  });

  DiscoveryState copyWith({
    Discovery? currentDiscovery,
    List<FocusSession>? sessions,
    Planet? planet,
  }) {
    return DiscoveryState(
      currentDiscovery: currentDiscovery ?? this.currentDiscovery,
      sessions: sessions ?? this.sessions,
      planet: planet ?? this.planet,
    );
  }

  factory DiscoveryState.fromJson(Map<String, dynamic> json) => DiscoveryState(
        currentDiscovery: json['currentDiscovery'] != null
            ? Discovery.fromJson(json['currentDiscovery'])
            : null,
        sessions: (json['sessions'] as List<dynamic>?)
                ?.map((e) => FocusSession.fromJson(e))
                .toList() ??
            [],
        planet: json['planet'] != null ? Planet.fromJson(json['planet']) : null,
      );

  Map<String, dynamic> toJson() => {
        'currentDiscovery': currentDiscovery?.toJson(),
        'sessions': sessions.map((e) => e.toJson()).toList(),
        'planet': planet?.toJson(),
      };
}

class DiscoveryManager extends Observer<DiscoveryState> {
  static final DiscoveryManager _instance = DiscoveryManager._internal();
  static DiscoveryManager get instance => _instance;

  DiscoveryState _state;

  DiscoveryManager._internal()
      : _state = DiscoveryState(
          currentDiscovery: null,
          sessions: [],
          planet: null,
        );

  DiscoveryState get state => _state;

  void _updateState(DiscoveryState state) {
    _state = state;
    notifyListeners(state);
  }

  Future<void> initializeCurrentDiscovery() async {
    if (_state.currentDiscovery != null) {
      return;
    }

    // 1. currentDiscovery 초기화
    final discovery =
        await DiscoveryRepository.instance.getOrCreateActiveDiscovery();

    // 2. 세션 리스트 초기화
    List<FocusSession> sessions = [];
    if (discovery.sessionIds.isNotEmpty) {
      sessions = await FocusSessionRepository.instance
          .getFocusSessionsByIds(discovery.sessionIds);
    }

    // 3. planet 초기화
    Planet? planet;
    planet = await PlanetRepository.instance.getPlanetById(discovery.planetId);

    // 상태 업데이트
    _updateState(_state.copyWith(
      currentDiscovery: discovery,
      sessions: sessions,
      planet: planet,
    ));
  }

  Future<void> finishCurrentDiscovery() async {
    if (_state.currentDiscovery != null) {
      await DiscoveryRepository.instance
          .finishDiscovery(_state.currentDiscovery!.id);
    }
  }

  Future<void> addSession(int sessionId) async {
    await DiscoveryRepository.instance.addSessionIdToDiscovery(sessionId);
    final session = await FocusSessionRepository.instance
        .getFocusSessionsByIds([sessionId]);

    _updateState(_state.copyWith(
      sessions: [..._state.sessions, ...session],
    ));
  }
}
