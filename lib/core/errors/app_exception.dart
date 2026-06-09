class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException([this.message = 'Something went wrong', this.prefix]);

  @override
  String toString() => '$prefix$message';
}
