class BodyMeasurements {
  final double? heightCm;
  final double? bustChestCm;
  final double? waistCm;
  final double? hipsCm;
  final String unit;

  const BodyMeasurements({
    this.heightCm,
    this.bustChestCm,
    this.waistCm,
    this.hipsCm,
    this.unit = 'cm',
  });

  static const empty = BodyMeasurements();

  bool get isNotEmpty =>
      heightCm != null || bustChestCm != null || waistCm != null || hipsCm != null;

  Map<String, dynamic> toMap() => {
    'heightCm': heightCm,
    'bustChestCm': bustChestCm,
    'waistCm': waistCm,
    'hipsCm': hipsCm,
    'unit': unit,
  };

  factory BodyMeasurements.fromMap(Map<String, dynamic> map) => BodyMeasurements(
    heightCm: (map['heightCm'] as num?)?.toDouble(),
    bustChestCm: (map['bustChestCm'] as num?)?.toDouble(),
    waistCm: (map['waistCm'] as num?)?.toDouble(),
    hipsCm: (map['hipsCm'] as num?)?.toDouble(),
    unit: map['unit'] ?? 'cm',
  );
}

class BodyTypeOption {
  final String id;
  final String label;
  final String emoji;
  final String description;
  final String stylingTip;

  const BodyTypeOption({
    required this.id,
    required this.label,
    required this.emoji,
    required this.description,
    required this.stylingTip,
  });
}

class BodyTypeCatalog {
  static List<BodyTypeOption> forGender(String? gender) {
    if (gender == 'Female') {
      return const [
        BodyTypeOption(
          id: 'hourglass',
          label: 'Hourglass',
          emoji: '⏳',
          description: 'Balanced bust and hips with a defined waist.',
          stylingTip: 'Highlight your waist with wrap dresses and belted coats.',
        ),
        BodyTypeOption(
          id: 'pear',
          label: 'Pear / Triangle',
          emoji: '🍐',
          description: 'Hips wider than your bust.',
          stylingTip: 'Draw attention to your upper body with structured jackets.',
        ),
        BodyTypeOption(
          id: 'apple',
          label: 'Apple / Round',
          emoji: '🍎',
          description: 'Broad shoulders and bust, undefined waist.',
          stylingTip: 'Empire waistlines and V-necks look great on you.',
        ),
        BodyTypeOption(
          id: 'rectangle',
          label: 'Rectangle / Athletic',
          emoji: '📏',
          description: 'Bust, waist, and hips have similar measurements.',
          stylingTip: 'Create curves with peplum tops and ruffled layers.',
        ),
      ];
    } else {
      return const [
        BodyTypeOption(
          id: 'inverted_triangle',
          label: 'Inverted Triangle',
          emoji: '🔻',
          description: 'Broad shoulders tapering to narrow hips.',
          stylingTip: 'Add volume to your lower body with cargo pants or wider fits.',
        ),
        BodyTypeOption(
          id: 'rectangle',
          label: 'Rectangle',
          emoji: '📏',
          description: 'Shoulders, chest, and hips are roughly equal.',
          stylingTip: 'Structured blazers and layered looks add dimension.',
        ),
        BodyTypeOption(
          id: 'oval',
          label: 'Oval / Apple',
          emoji: '⭕',
          description: 'The center of your torso is wider than shoulders/hips.',
          stylingTip: 'Vertical stripes and well-fitted (not tight) shirts work best.',
        ),
        BodyTypeOption(
          id: 'triangle',
          label: 'Triangle',
          emoji: '📐',
          description: 'Hips and waist are wider than your shoulders.',
          stylingTip: 'Focus on structured shoulder items to balance your frame.',
        ),
      ];
    }
  }
}
