class FocusSession {
  /// DocumentStore가 부여하는 자동 증가 id. 저장 전에는 null이다.
  int? id;

  late String activity;
  late int focusedTime;
  late int restTime;
  late DateTime date;

  FocusSession({
    this.id,
    required this.activity,
    required this.focusedTime,
    required this.restTime,
    required this.date,
  });

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
        id: json['id'] as int?,
        activity: json['activity'] as String,
        focusedTime: json['focusedTime'] as int,
        restTime: json['restTime'] as int,
        date: DateTime.parse(json['date'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'activity': activity,
        'focusedTime': focusedTime,
        'restTime': restTime,
        'date': date.toIso8601String(),
      };
}
