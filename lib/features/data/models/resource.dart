class Resource {
  final String id;
  final String resourceType;
  final int version;
  final DateTime addedAt;
  final String? description;
  final String name;

// plaent
  final String? url;

  // character
  final List<int>? travelframes;
  final String? travelSprite;
  final String? idleSprite;
  final List<int>? idleFrames;
  final bool? isPremium;

  Resource({
    required this.id,
    required this.resourceType,
    required this.version,
    required this.addedAt,
    required this.description,
    required this.name,
    required this.url,
    required this.travelframes,
    required this.travelSprite,
    required this.idleSprite,
    required this.idleFrames,
    required this.isPremium,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      resourceType: json['resourceType'],
      version: json['version'],
      addedAt: json['addedAt'],
      description: json['description'],
      name: json['name'],
      url: json['url'],
      travelframes: json['travelframes'],
      travelSprite: json['travelSprite'],
      idleSprite: json['idleSprite'],
      idleFrames: json['idleFrames'],
      isPremium: json['isPremium'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resourceType': resourceType,
      'version': version,
      'addedAt': addedAt,
      'description': description,
      'name': name,
      'url': url,
      'travelframes': travelframes,
      'travelSprite': travelSprite,
      'idleSprite': idleSprite,
      'idleFrames': idleFrames,
      'isPremium': isPremium,
    };
  }
}
