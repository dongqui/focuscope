class Audio {
  /// DocumentStore가 부여하는 자동 증가 id. 저장 전에는 null이다.
  int? id;

  late List<String> whiteNoise;
  late String currentMusic;
  late bool isMusicOn;

  Audio({
    this.id,
    required this.whiteNoise,
    required this.currentMusic,
    required this.isMusicOn,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        id: json['id'] as int?,
        whiteNoise: List<String>.from(json['whiteNoise'] as List),
        currentMusic: json['currentMusic'] as String,
        isMusicOn: json['isMusicOn'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'whiteNoise': whiteNoise,
        'currentMusic': currentMusic,
        'isMusicOn': isMusicOn,
      };
}
