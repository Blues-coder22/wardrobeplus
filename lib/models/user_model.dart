import 'body_type_model.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? gender;
  final String? bodyType;             // optional — user may skip
  final BodyMeasurements measurements; // optional — user may fill some/none
  final String? stylePreference;       // primary style id from StyleCatalog
  final List<String> additionalStyles; // secondary style ids (multi-select)
  final bool isPremium;
  final bool emailVerified;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.gender,
    this.bodyType,
    this.measurements = BodyMeasurements.empty,
    this.stylePreference,
    this.additionalStyles = const [],
    this.isPremium = false,
    this.emailVerified = false,
    this.createdAt,
  });

  // Empty/guest user
  static const empty = UserModel(id: '', email: '', name: '');

  bool get isEmpty  => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  /// Has the user provided SOME body info — either a body type or measurements?
  bool get hasBodyInfo => bodyType != null || measurements.isNotEmpty;

  /// Onboarding is complete once gender + style are set.
  /// Body type/measurements are optional, so they don't block completion.
  bool get hasCompletedOnboarding =>
      gender != null && stylePreference != null;

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? gender,
    String? bodyType,
    BodyMeasurements? measurements,
    String? stylePreference,
    List<String>? additionalStyles,
    bool? isPremium,
    bool? emailVerified,
    DateTime? createdAt,
    bool clearBodyType = false,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      bodyType: clearBodyType ? null : (bodyType ?? this.bodyType),
      measurements: measurements ?? this.measurements,
      stylePreference: stylePreference ?? this.stylePreference,
      additionalStyles: additionalStyles ?? this.additionalStyles,
      isPremium: isPremium ?? this.isPremium,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'name': name,
    'gender': gender,
    'bodyType': bodyType,
    'measurements': measurements.toMap(),
    'stylePreference': stylePreference,
    'additionalStyles': additionalStyles,
    'isPremium': isPremium,
    'emailVerified': emailVerified,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] ?? '',
    email: map['email'] ?? '',
    name: map['name'] ?? '',
    gender: map['gender'],
    bodyType: map['bodyType'],
    measurements: map['measurements'] != null
        ? BodyMeasurements.fromMap(Map<String, dynamic>.from(map['measurements']))
        : BodyMeasurements.empty,
    stylePreference: map['stylePreference'],
    additionalStyles: List<String>.from(map['additionalStyles'] ?? []),
    isPremium: map['isPremium'] ?? false,
    emailVerified: map['emailVerified'] ?? false,
    createdAt: map['createdAt'] != null
        ? DateTime.tryParse(map['createdAt'])
        : null,
  );
}
