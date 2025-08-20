class ServerResourceInfo {
  final String resourceType;
  final String version;
  final DateTime lastUpdated;
  final List<ResourceItem> items;

  ServerResourceInfo({
    required this.resourceType,
    required this.version,
    required this.lastUpdated,
    required this.items,
  });

  factory ServerResourceInfo.fromJson(Map<String, dynamic> json) {
    return ServerResourceInfo(
      resourceType: json['resourceType'],
      version: json['version'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      items: (json['items'] as List)
          .map((item) => ResourceItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'resourceType': resourceType,
        'version': version,
        'lastUpdated': lastUpdated.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
      };
}

class ResourceItem {
  final int id;
  final String name;
  final String imageUrl;
  final bool isPremium;
  final Map<String, dynamic> additionalData;

  ResourceItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isPremium,
    this.additionalData = const {},
  });

  factory ResourceItem.fromJson(Map<String, dynamic> json) {
    return ResourceItem(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      isPremium: json['isPremium'] ?? false,
      additionalData: json['additionalData'] ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'isPremium': isPremium,
        'additionalData': additionalData,
      };
}
