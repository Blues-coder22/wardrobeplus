class ClothingItemModel {
  final String id;
  final String name;
  final String category;
  final String? imageUrl;
  final List<String> tags;
  final int wearCount;
  final String? colorHex;
  final DateTime? addedAt;
  final DateTime? lastWornAt;

  const ClothingItemModel({
    required this.id,
    required this.name,
    required this.category,
    this.imageUrl,
    this.tags = const [],
    this.wearCount = 0,
    this.colorHex,
    this.addedAt,
    this.lastWornAt,
  });

  ClothingItemModel copyWith({
    String? name,
    String? category,
    String? imageUrl,
    List<String>? tags,
    int? wearCount,
    String? colorHex,
    DateTime? lastWornAt,
  }) {
    return ClothingItemModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      wearCount: wearCount ?? this.wearCount,
      colorHex: colorHex ?? this.colorHex,
      addedAt: addedAt,
      lastWornAt: lastWornAt ?? this.lastWornAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'category': category,
    'imageUrl': imageUrl,
    'tags': tags,
    'wearCount': wearCount,
    'colorHex': colorHex,
    'addedAt': addedAt?.toIso8601String(),
    'lastWornAt': lastWornAt?.toIso8601String(),
  };

  factory ClothingItemModel.fromMap(Map<String, dynamic> map) =>
      ClothingItemModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        category: map['category'] ?? '',
        imageUrl: map['imageUrl'],
        tags: List<String>.from(map['tags'] ?? []),
        wearCount: map['wearCount'] ?? 0,
        colorHex: map['colorHex'],
        addedAt: map['addedAt'] != null ? DateTime.tryParse(map['addedAt']) : null,
        lastWornAt: map['lastWornAt'] != null ? DateTime.tryParse(map['lastWornAt']) : null,
      );
}
