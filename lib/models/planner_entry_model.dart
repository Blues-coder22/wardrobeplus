import 'outfit_model.dart';

class PlannerEntryModel {
  final String id;
  final DateTime date;
  final OutfitModel outfit;
  final String? note;

  const PlannerEntryModel({
    required this.id,
    required this.date,
    required this.outfit,
    this.note,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'outfit': outfit.toMap(),
    'note': note,
  };

  factory PlannerEntryModel.fromMap(Map<String, dynamic> map) => PlannerEntryModel(
    id: map['id'] ?? '',
    date: DateTime.parse(map['date']),
    outfit: OutfitModel.fromMap(Map<String, dynamic>.from(map['outfit'])),
    note: map['note'],
  );
}
