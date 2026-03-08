import 'package:dio/dio.dart';
import '../core/config/api_config.dart';
import '../models/api_response.dart';
import 'secure_storage_service.dart';

/// API Client with JWT token handling and auto-refresh
/// 
/// Features:
/// - Automatic JWT token injection
/// - Token refresh on 401 errors
/// - Request/Response logging
/// - Error handling
class ApiClient {
  late final Dio _dio;
  final SecureStorageService _storage = SecureStorageService();

  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor(_storage, _dio));
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return ApiResponse.success(fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse.failure(_handleError(e));
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return ApiResponse.success(fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse.failure(_handleError(e));
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.patch(path, data: data);
      return ApiResponse.success(fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse.failure(_handleError(e));
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.delete(path);
      return ApiResponse.success(fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse.failure(_handleError(e));
    }
  }

  /// Handle Dio errors
  ApiError _handleError(DioException error) {
    if (error.response != null) {
      // Server responded with error
      return ApiError.fromJson(error.response!.data);
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiError(
        message: 'Connection timeout. Please check your internet connection.',
        statusCode: 408,
      );
    } else if (error.type == DioExceptionType.connectionError) {
      return ApiError(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } else {
      return ApiError(
        message: error.message ?? 'An unexpected error occurred',
      );
    }
  }
}

/// Auth Interceptor for automatic token injection and refresh
class _AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _dio;

  _AuthInterceptor(this._storage, this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token injection for auth endpoints
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/register')) {
      return handler.next(options);
    }

    // Add access token to request headers
    final accessToken = await _storage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      // Try to refresh the token
      final refreshToken = await _storage.getRefreshToken();
      
      if (refreshToken != null) {
        try {
          // Call refresh token endpoint
          final response = await _dio.post(
            ApiConfig.refresh,
            data: {'refreshToken': refreshToken},
          );

          // Save new tokens
          final newAccessToken = response.data['tokens']['accessToken'];
          final newRefreshToken = response.data['tokens']['refreshToken'];
          
          await _storage.saveAccessToken(newAccessToken);
          await _storage.saveRefreshToken(newRefreshToken);

          // Retry the original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';
          
          final retryResponse = await _dio.fetch(options);
          return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh failed - clear tokens and redirect to login
          await _storage.clearAll();
          return handler.reject(err);
        }
      }
    }

    return handler.next(err);
  }
}
