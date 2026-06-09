// Auth-specific exceptions
class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  factory AuthException.fromCode(String code) {
    switch (code) {
      case 'user-not-found':
        return const AuthException('No account found with this email.');
      case 'wrong-password':
        return const AuthException('Incorrect password. Please try again.');
      case 'email-already-in-use':
        return const AuthException('An account already exists with this email.');
      case 'weak-password':
        return const AuthException('Password is too weak. Use 8+ characters.');
      case 'invalid-email':
        return const AuthException('The email address is not valid.');
      case 'too-many-requests':
        return const AuthException('Too many attempts. Please try again later.');
      case 'network-request-failed':
        return const AuthException('No internet connection. Check your network.');
      case 'user-disabled':
        return const AuthException('This account has been disabled.');
      default:
        return AuthException('Something went wrong. Code: $code');
    }
  }

  @override
  String toString() => message;
}

// General app exception
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
