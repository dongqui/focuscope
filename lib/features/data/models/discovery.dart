class Discovery {
  /// DocumentStore가 부여하는 자동 증가 id. 저장 전에는 null이다.
  int? id;

  List<int> sessionIds;
  int planetId;
  bool isFinished;

  Discovery({
    this.id,
    required this.sessionIds,
    required this.planetId,
    required this.isFinished,
  });

  factory Discovery.fromJson(Map<String, dynamic> json) => Discovery(
        id: json['id'] as int?,
        sessionIds: List<int>.from(json['sessionIds'] as List, growable: true),
        planetId: json['planetId'] as int,
        isFinished: json['isFinished'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionIds': sessionIds,
        'planetId': planetId,
        'isFinished': isFinished,
      };
}
