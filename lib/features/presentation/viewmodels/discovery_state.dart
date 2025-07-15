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
  final List<Planet> planets; // planets 리스트 추가

  DiscoveryState({
    required this.currentDiscovery,
    required this.sessions,
    required this.planet,
    this.planets = const [], // 기본값 추가
  });

  DiscoveryState copyWith({
    Discovery? currentDiscovery,
    List<FocusSession>? sessions,
    Planet? planet,
    List<Planet>? planets, // copyWith에 planets 추가
  }) {
    return DiscoveryState(
      currentDiscovery: currentDiscovery ?? this.currentDiscovery,
      sessions: sessions ?? this.sessions,
      planet: planet ?? this.planet,
      planets: planets ?? this.planets, // planets 반영
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
        planets: (json['planets'] as List<dynamic>?)
                ?.map((e) => Planet.fromJson(e))
                .toList() ??
            [], // planets 역직렬화
      );

  Map<String, dynamic> toJson() => {
        'currentDiscovery': currentDiscovery?.toJson(),
        'sessions': sessions.map((e) => e.toJson()).toList(),
        'planet': planet?.toJson(),
        'planets': planets.map((e) => e.toJson()).toList(), // planets 직렬화
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
          planets: [], // planets 초기화
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

  // isFinished된 Discovery의 planet 리스트만 반환
  Future<List<Planet>> fetchFinishedPlanets() async {
    if (_state.planets.isNotEmpty) {
      return _state.planets;
    }

    final discoveries =
        await DiscoveryRepository.instance.getFinishedDiscoveries();

    final planetIds = discoveries.map((e) => e.planetId).toList();
    final planets = await PlanetRepository.instance.getPlanetsByIds(planetIds);

    // null이 아닌 값만 반환
    final nonNullPlanets = planets.whereType<Planet>().toList();
    _updateState(_state.copyWith(planets: nonNullPlanets));
    return nonNullPlanets;
  }
}
