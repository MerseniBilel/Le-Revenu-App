class HttpResponse {
  final int statusCode;
  final dynamic body;
  HttpResponse({required this.statusCode, required this.body});
}

abstract class ApiConsumer {
  Future<HttpResponse> get(String path, {Map<String, String> headers});

  Future<HttpResponse> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  });

  Future<HttpResponse> patch(
    String path, {
    Object? body,
    Map<String, String>? headers,
  });

  Future<HttpResponse> delete(
    String path, {
    Object? body,
    Map<String, String>? headers,
  });

  Future<HttpResponse> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
  });
}
