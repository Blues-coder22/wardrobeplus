import 'package:flutter/material.dart';
import '../core/errors/auth_exception.dart';
import '../models/user_model.dart';
import '../models/body_type_model.dart';
import '../services/auth/auth_service.dart';
import '../services/storage/local_storage_service.dart';

enum AuthStatus {
  initial,       // app just launched, haven't checked yet
  checking,      // restoring session
  authenticated, // logged in
  unauthenticated, // logged out
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService) {
    _init();
  }

  AuthStatus _status = AuthStatus.initial;
  UserModel _user = UserModel.empty;
  String? _errorMessage;
  bool _isLoading = false;

  // ── Getters ──────────────────────────────────────────────────
  AuthStatus get status        => _status;
  UserModel  get user          => _user;
  String?    get errorMessage  => _errorMessage;
  bool       get isLoading     => _isLoading;
  bool       get isLoggedIn    => _status == AuthStatus.authenticated;
  bool       get isFirstLaunch => LocalStorageService.isFirstLaunch();
  bool       get hasCompletedOnboarding =>
      LocalStorageService.hasCompletedOnboarding();

  // ── Initialise: restore session on app launch ────────────────
  Future<void> _init() async {
    _status = AuthStatus.checking;
    notifyListeners();

    try {
      final user = await _authService.restoreSession();
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // ── Sign in ──────────────────────────────────────────────────
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    try {
      final user = await _authService.signInWithEmail(
        email: email, password: password,
      );
      _user = user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Register ─────────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await _authService.registerWithEmail(
        name: name, email: email, password: password,
      );
      _user = user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Sign out ─────────────────────────────────────────────────
  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _user = UserModel.empty;
    _status = AuthStatus.unauthenticated;
    _setLoading(false);
  }

  // ── Forgot password ──────────────────────────────────────────
  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email);
      _errorMessage = null;
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Save onboarding selections ────────────────────────────────
  Future<void> saveGender(String gender) async {
    await _authService.updateProfile(gender: gender);
    _user = _user.copyWith(gender: gender);
    notifyListeners();
  }

  /// Save body type selection (optional step — can be skipped)
  Future<void> saveBodyType(String bodyType) async {
    await _authService.updateProfile(bodyType: bodyType);
    _user = _user.copyWith(bodyType: bodyType);
    notifyListeners();
  }

  /// Skip body type selection entirely
  Future<void> skipBodyType() async {
    await _authService.updateProfile(clearBodyType: true);
    _user = _user.copyWith(clearBodyType: true);
    notifyListeners();
  }

  /// Save body measurements (independent of body type — can have both or either)
  Future<void> saveMeasurements(BodyMeasurements measurements) async {
    await _authService.updateProfile(measurements: measurements);
    _user = _user.copyWith(measurements: measurements);
    notifyListeners();
  }

  /// Save the user's primary style preference + optional secondary styles
  Future<void> saveStylePreferences({
    required String primaryStyle,
    List<String> additionalStyles = const [],
  }) async {
    await _authService.updateProfile(
      stylePreference: primaryStyle,
      additionalStyles: additionalStyles,
    );
    await LocalStorageService.setOnboardingComplete();
    _user = _user.copyWith(
      stylePreference: primaryStyle,
      additionalStyles: additionalStyles,
    );
    notifyListeners();
  }

  // ── Clear error ───────────────────────────────────────────────
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }
}
