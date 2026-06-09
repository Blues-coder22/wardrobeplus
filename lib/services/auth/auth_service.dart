import '../../models/user_model.dart';
import '../../models/body_type_model.dart';

abstract class AuthService {
  Future<UserModel?> restoreSession();
  
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updateProfile({
    String? name,
    String? gender,
    String? bodyType,
    bool clearBodyType = false,
    BodyMeasurements? measurements,
    String? stylePreference,
    List<String>? additionalStyles,
  });

  void dispose();
}
