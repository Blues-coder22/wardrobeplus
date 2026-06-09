import '../../models/user_model.dart';
import '../../models/body_type_model.dart';
import 'auth_service.dart';

class GoogleAuthService implements AuthService {
  @override
  Future<UserModel?> restoreSession() async => null;

  @override
  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    throw UnimplementedError('Use signInWithGoogle instead');
  }

  @override
  Future<UserModel> registerWithEmail({required String name, required String email, required String password}) async {
    throw UnimplementedError('Use signInWithGoogle instead');
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> updateProfile({
    String? name,
    String? gender,
    String? bodyType,
    bool clearBodyType = false,
    BodyMeasurements? measurements,
    String? stylePreference,
    List<String>? additionalStyles,
  }) async {}

  @override
  void dispose() {}
}
