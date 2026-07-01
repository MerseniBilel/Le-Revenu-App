import 'package:dio/dio.dart';
import 'api_consumer.dart';
import 'package:injectable/injectable.dart';
import 'dio_interceptor.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio get dioClient => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}

@LazySingleton(as: ApiConsumer)
class DioConsumer implements ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<HttpResponse> _makeRequest(Future<Response> Function() request) async {
    try {
      final response = await request();
      return HttpResponse(
        statusCode: response.statusCode ?? 500,
        body: response.data,
      );
    } on DioException catch (e) {
      return HttpResponse(
        statusCode: e.response?.statusCode ?? 500,
        body: e.response?.data ?? {'error': e.message},
      );
    }
  }

  @override
  Future<HttpResponse> get(String path, {Map<String, String>? headers}) {
    return _makeRequest(
      () => dio.get(path, options: Options(headers: headers)),
    );
  }

  @override
  Future<HttpResponse> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return _makeRequest(
      () => dio.post(
        path,
        data: body,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<HttpResponse> delete(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return _makeRequest(
      () => dio.delete(
        path,
        data: body,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<HttpResponse> patch(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return _makeRequest(
      () => dio.patch(
        path,
        data: body,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<HttpResponse> put(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return _makeRequest(
      () => dio.put(
        path,
        data: body,
        options: Options(headers: headers),
      ),
    );
  }
}
