import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../models/body_type_model.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserModel?> restoreSession() async {
    final user = _auth.currentUser;
    if (user != null) {
      // In a real app, you would fetch the rest from Firestore
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
      );
    }
    return null;
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
    );
  }

  @override
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(name);
    return UserModel(
      id: user.uid,
      email: email,
      name: name,
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updateProfile({
    String? name,
    String? gender,
    String? bodyType,
    bool clearBodyType = false,
    BodyMeasurements? measurements,
    String? stylePreference,
    List<String>? additionalStyles,
  }) async {
    // In a real app, update Firestore here
  }

  @override
  void dispose() {}
}
