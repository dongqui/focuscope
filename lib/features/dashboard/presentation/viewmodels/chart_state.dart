import 'package:catodo/core/observer.dart';
import 'package:catodo/core/utils/date_helper.dart';

enum DateUnit {
  day,
  week,
  month,
  year,
}

class ChartState {
  DateUnit currentDateUnit;
  DateTime selectedDate;

  ChartState({
    this.currentDateUnit = DateUnit.week,
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();
}

class ChartManager extends Observer<ChartState> {
  static final ChartManager _instance = ChartManager._internal();
  static ChartManager get instance => _instance;
  ChartManager._internal() : _state = ChartState();

  final ChartState _state;

  ChartState get state => _state;

  void updateDateUnit(DateUnit unit) {
    _state.currentDateUnit = unit;
    notifyListeners(_state);
  }

  void moveNext() {
    switch (_state.currentDateUnit) {
      case DateUnit.day:
        _state.selectedDate = DateHelper.getNextDay(_state.selectedDate);
        break;
      case DateUnit.week:
        _state.selectedDate = DateHelper.getNextWeek(_state.selectedDate);
        break;
      case DateUnit.month:
        _state.selectedDate = DateHelper.getNextMonth(_state.selectedDate);
        break;
      case DateUnit.year:
        _state.selectedDate = DateHelper.getNextYear(_state.selectedDate);
        break;
    }
    notifyListeners(_state);
  }

  void movePrevious() {
    switch (_state.currentDateUnit) {
      case DateUnit.day:
        _state.selectedDate = DateHelper.getPreviousDay(_state.selectedDate);
        break;
      case DateUnit.week:
        _state.selectedDate = DateHelper.getPreviousWeek(_state.selectedDate);
        break;
      case DateUnit.month:
        _state.selectedDate = DateHelper.getPreviousMonth(_state.selectedDate);
        break;
      case DateUnit.year:
        _state.selectedDate = DateHelper.getPreviousYear(_state.selectedDate);
        break;
    }
    notifyListeners(_state);
  }

  String getFormattedDateRange() {
    return DateHelper.getFormattedDateRange(
        _state.currentDateUnit, _state.selectedDate);
  }
}
