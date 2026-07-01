class ServerException implements Exception {
  final String? serverError;

  ServerException({this.serverError});
}
