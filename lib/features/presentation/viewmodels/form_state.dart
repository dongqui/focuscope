import 'package:catodo/features/data/models/latest-activity-model.dart';
import 'package:catodo/features/data/repositories/focus_session_repository.dart';
import 'package:catodo/features/data/models/focus_session_model.dart';
import 'package:catodo/constants/index.dart';
import 'package:catodo/features/data/repositories/latest_activity_repository.dart';

class FocusForm {
  final String activity;
  final int duration;
  final DateTime date;

  const FocusForm({
    required this.activity,
    required this.duration,
    required this.date,
  });

  FocusForm copyWith({
    String? activity,
    int? duration,
    DateTime? date,
  }) {
    return FocusForm(
      activity: activity ?? this.activity,
      duration: duration ?? this.duration,
      date: date ?? this.date,
    );
  }
}

class FormManager {
  static final FormManager _instance = FormManager._internal();
  static FormManager get instance => _instance;

  FocusForm _state;
  final List<void Function(FocusForm)> _listeners = [];

  FormManager._internal()
      : _state = FocusForm(
          activity: '',
          duration: DEFAULT_WORK_TIME,
          date: DateTime.now(),
        );

  FocusForm get state => _state;

  Future<List<LatestActivity>> getLatestActivities() async {
    return await LatestActivityRepository.instance.getLatestActivities();
  }

  void addListener(void Function(FocusForm) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(FocusForm) listener) {
    _listeners.remove(listener);
  }

  void updateActivity(String activity) {
    _updateState(_state.copyWith(activity: activity));
  }

  void updateDuration(int duration) {
    _updateState(_state.copyWith(duration: duration));
  }

  void _updateState(FocusForm newState) {
    _state = newState;
    for (var listener in _listeners) {
      listener(_state);
    }
  }

  void save(int focussedTime) {
    FocusSessionRepository.instance.addFocusSession(FocusSession(
      activity: _state.activity,
      focusedTime: focussedTime,
      restTime: 0,
      date: _state.date,
    ));
  }
}
