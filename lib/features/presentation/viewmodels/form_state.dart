import 'package:catodo/features/data/models/latest-activity-model.dart';
import 'package:catodo/features/data/repositories/focus_session_repository.dart';
import 'package:catodo/features/data/models/focus_session_model.dart';
import 'package:catodo/constants/index.dart';
import 'package:catodo/features/data/repositories/latest_activity_repository.dart';

class FocusFormState {
  final String activity;
  final int duration;
  final DateTime date;
  final List<String> latestActivities;
  final bool isFocused;

  const FocusFormState({
    required this.activity,
    required this.duration,
    required this.date,
    required this.latestActivities,
    this.isFocused = false,
  });

  FocusFormState copyWith({
    String? activity,
    int? duration,
    DateTime? date,
    List<String>? latestActivities,
    bool? isFocused,
  }) {
    return FocusFormState(
      activity: activity ?? this.activity,
      duration: duration ?? this.duration,
      date: date ?? this.date,
      latestActivities: latestActivities ?? this.latestActivities,
      isFocused: isFocused ?? this.isFocused,
    );
  }
}

class FormManager {
  static final FormManager _instance = FormManager._internal();
  static FormManager get instance => _instance;

  FocusFormState _state;
  final List<void Function(FocusFormState)> _listeners = [];

  FormManager._internal()
      : _state = FocusFormState(
          activity: '',
          duration: DEFAULT_WORK_TIME,
          date: DateTime.now(),
          latestActivities: [],
          isFocused: false,
        );

  FocusFormState get state => _state;

  Future<List<LatestActivity>> getLatestActivities() async {
    final activities =
        await LatestActivityRepository.instance.getLatestActivities();
    _updateState(_state.copyWith(
        latestActivities: activities.map((e) => e.name).toList()));
    return activities;
  }

  void removeLatestActivity(String activity) async {
    await LatestActivityRepository.instance.removeLatestActivity(activity);
    _updateState(_state.copyWith(
        latestActivities:
            _state.latestActivities.where((e) => e != activity).toList()));
  }

  void addLatestActivity() {
    if (!_state.latestActivities.contains(_state.activity)) {
      LatestActivityRepository.instance.addLatestActivity(LatestActivity(
        name: _state.activity,
        timestamp: DateTime.now(),
      ));
      _updateState(_state.copyWith(
          latestActivities: [..._state.latestActivities, _state.activity]));
    }
  }

  void addListener(void Function(FocusFormState) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(FocusFormState) listener) {
    _listeners.remove(listener);
  }

  void updateActivity(String activity) {
    _updateState(_state.copyWith(activity: activity));
  }

  void updateDuration(int duration) {
    _updateState(_state.copyWith(duration: duration));
  }

  void _updateState(FocusFormState newState) {
    _state = newState;
    for (var listener in _listeners) {
      listener(_state);
    }
  }

  void updateIsFocused(bool isFocused) {
    _updateState(_state.copyWith(isFocused: isFocused));
  }

  Future<int> save(int focussedTime) async {
    final session = FocusSession(
      activity: _state.activity,
      focusedTime: focussedTime,
      restTime: 0,
      date: _state.date,
    );
    return await FocusSessionRepository.instance.addFocusSession(session);
  }
}
