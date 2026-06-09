import 'clothing_item_model.dart';

class OutfitModel {
  final String id;
  final String? name;
  final List<ClothingItemModel> items;
  final DateTime? createdAt;
  final int wearCount;
  final bool isAiGenerated;

  const OutfitModel({
    required this.id,
    this.name,
    this.items = const [],
    this.createdAt,
    this.wearCount = 0,
    this.isAiGenerated = false,
  });

  OutfitModel copyWith({
    String? name,
    List<ClothingItemModel>? items,
    int? wearCount,
  }) {
    return OutfitModel(
      id: id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt,
      wearCount: wearCount ?? this.wearCount,
      isAiGenerated: isAiGenerated,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'items': items.map((i) => i.toMap()).toList(),
    'createdAt': createdAt?.toIso8601String(),
    'wearCount': wearCount,
    'isAiGenerated': isAiGenerated,
  };

  factory OutfitModel.fromMap(Map<String, dynamic> map) => OutfitModel(
    id: map['id'] ?? '',
    name: map['name'],
    items: (map['items'] as List?)
            ?.map((i) => ClothingItemModel.fromMap(Map<String, dynamic>.from(i)))
            .toList() ??
        [],
    createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
    wearCount: map['wearCount'] ?? 0,
    isAiGenerated: map['isAiGenerated'] ?? false,
  );
}
