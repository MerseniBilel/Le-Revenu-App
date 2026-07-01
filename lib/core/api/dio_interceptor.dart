import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Content-Type"] = "application/json";
    options.headers["Accept"] = "application/json";
    options.headers["Authorization"] = "Bearer ";

    super.onRequest(options, handler);
  }
}
