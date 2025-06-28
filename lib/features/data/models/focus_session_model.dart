import 'package:isar/isar.dart';

part 'focus_session_model.g.dart';

@Collection()
class FocusSession {
  Id id = Isar.autoIncrement; // 자동 증가 ID

  late String activity;
  late int focusedTime;
  late int restTime;
  late DateTime date;

  FocusSession({
    required this.activity,
    required this.focusedTime,
    required this.restTime,
    required this.date,
  });

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
        activity: json['activity'],
        focusedTime: json['focusedTime'],
        restTime: json['restTime'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'activity': activity,
        'focusedTime': focusedTime,
        'restTime': restTime,
        'date': date.toIso8601String()
      };
}
