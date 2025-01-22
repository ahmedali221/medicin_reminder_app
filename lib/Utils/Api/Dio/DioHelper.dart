import 'package:dio/dio.dart';

class DioHelper {
  // Singleton instance
  static final DioHelper _instance = DioHelper._internal();
  factory DioHelper() => _instance;
  DioHelper._internal() {
    // Initialize Dio with base options
    _dio = Dio(BaseOptions(
      baseUrl:
          'https://odphp.health.gov/myhealthfinder/api/v3/', // Your API base URL
      connectTimeout: const Duration(seconds: 10), // Connection timeout
      receiveTimeout: const Duration(seconds: 10), // Receive timeout
      headers: {
        'Content-Type': 'application/json', // Default headers
      },
    ));

    // // Add interceptors (optional)
    // _dio.interceptors.add(LogInterceptor(
    //   request: true,
    //   requestHeader: true,
    //   requestBody: true,
    //   responseHeader: true,
    //   responseBody: true,
    //   error: true,
    // ));
  }

  late final Dio _dio;

  // Getter for Dio instance
  Dio get dio => _dio;

  // Helper methods for HTTP requests

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        // queryParameters: queryParameters,
        // options: options,
        // cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  dynamic _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectionTimeout:
        throw 'Connection timeout';
      case DioErrorType.sendTimeout:
        throw 'Send timeout';
      case DioErrorType.receiveTimeout:
        throw 'Receive timeout';
      case DioErrorType.badResponse:
        throw 'Bad response: ${error.response?.statusCode}';
      case DioErrorType.cancel:
        throw 'Request canceled';
      case DioErrorType.unknown:
        throw 'Unknown error: ${error.message}';
      default:
        throw 'Something went wrong';
    }
  }
}
