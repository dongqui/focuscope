import 'package:catodo/core/observer.dart';
import 'package:catodo/core/utils/date_helper.dart';
import 'package:catodo/features/data/repositories/focus_session_repository.dart';

typedef ActivityTimeTuple = (String, int);

enum DateUnit {
  day,
  week,
  month,
  year,
}

class ChartState {
  DateUnit currentDateUnit;
  DateTime selectedDate;
  List<List<ActivityTimeTuple>> focusSessions;
  bool isLoading = false;

  ChartState({
    this.currentDateUnit = DateUnit.week,
    DateTime? selectedDate,
    this.focusSessions = const [],
    this.isLoading = false,
  }) : selectedDate = selectedDate ?? DateTime.now();

  ChartState copyWith({
    DateUnit? currentDateUnit,
    DateTime? selectedDate,
    List<List<ActivityTimeTuple>>? focusSessions,
    bool? isLoading,
  }) {
    return ChartState(
      currentDateUnit: currentDateUnit ?? this.currentDateUnit,
      selectedDate: selectedDate ?? this.selectedDate,
      focusSessions: focusSessions ?? this.focusSessions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChartManager extends Observer<ChartState> {
  static final ChartManager _instance = ChartManager._internal();
  static ChartManager get instance => _instance;
  ChartManager._internal() : _state = ChartState();

  ChartState _state;

  ChartState get state => _state;

  void updateDateUnit(DateUnit unit) {
    _state = _state.copyWith(currentDateUnit: unit);
    getFocusSessions();
  }

  void moveNext() {
    switch (_state.currentDateUnit) {
      case DateUnit.day:
        _state = _state.copyWith(
            selectedDate: DateHelper.getNextDay(_state.selectedDate));
        break;
      case DateUnit.week:
        _state = _state.copyWith(
            selectedDate: DateHelper.getNextWeek(_state.selectedDate));
        break;
      case DateUnit.month:
        _state = _state.copyWith(
            selectedDate: DateHelper.getNextMonth(_state.selectedDate));
        break;
      case DateUnit.year:
        _state = _state.copyWith(
            selectedDate: DateHelper.getNextYear(_state.selectedDate));
        break;
    }
    getFocusSessions();
  }

  void movePrevious() {
    switch (_state.currentDateUnit) {
      case DateUnit.day:
        _state = _state.copyWith(
            selectedDate: DateHelper.getPreviousDay(_state.selectedDate));
        break;
      case DateUnit.week:
        _state = _state.copyWith(
            selectedDate: DateHelper.getPreviousWeek(_state.selectedDate));
        break;
      case DateUnit.month:
        _state = _state.copyWith(
            selectedDate: DateHelper.getPreviousMonth(_state.selectedDate));
        break;
      case DateUnit.year:
        _state = _state.copyWith(
            selectedDate: DateHelper.getPreviousYear(_state.selectedDate));
        break;
    }
    getFocusSessions();
  }

  String getFormattedDateRange() {
    return DateHelper.getFormattedDateRange(
        _state.currentDateUnit, _state.selectedDate);
  }

  Future<void> getFocusSessions() async {
    _state = _state.copyWith(
        focusSessions:
            await FocusSessionRepository.instance.getFocusSessionsByDateRange(
      _state.currentDateUnit,
      _state.selectedDate,
    ));

    notifyListeners(_state);
  }
}
