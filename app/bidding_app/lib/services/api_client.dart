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
    final baseUrl = ApiConfig.baseUrl;
    print('🔧 API Client initialized with baseUrl: $baseUrl');
    
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add custom debug logging interceptor
    _dio.interceptors.add(_DebugInterceptor());
    
    // Add auth interceptor
    _dio.interceptors.add(_AuthInterceptor(_storage, _dio));
    
    // Add detailed logging in debug mode
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print('📡 Dio: $obj'),
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
    print('🔴 API Error Details:');
    print('   Type: ${error.type}');
    print('   Message: ${error.message}');
    print('   URL: ${error.requestOptions.uri}');
    
    if (error.response != null) {
      // Server responded with error
      print('   Status Code: ${error.response!.statusCode}');
      print('   Response Data: ${error.response!.data}');
      return ApiError.fromJson(error.response!.data);
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiError(
        message: 'Connection timeout. Please check your internet connection.',
        statusCode: 408,
      );
    } else if (error.type == DioExceptionType.connectionError) {
      // Connection refused - likely backend not running or wrong URL
      String message = 'Cannot connect to server. ';
      if (error.message?.contains('Connection refused') ?? false) {
        message += 'Make sure the backend server is running. ';
        message += 'Current URL: ${error.requestOptions.baseUrl}';
      } else {
        message += 'Please check your network connection.';
      }
      
      return ApiError(
        message: message,
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

/// Debug Interceptor for detailed API request/response logging
class _DebugInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('┌─────────────────────────────────────────────────────────────');
    print('│ 🚀 REQUEST: ${options.method} ${options.uri}');
    print('│ Headers: ${options.headers}');
    if (options.data != null) {
      print('│ Body: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      print('│ Query: ${options.queryParameters}');
    }
    print('└─────────────────────────────────────────────────────────────');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('┌─────────────────────────────────────────────────────────────');
    print('│ ✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    print('│ Data: ${response.data}');
    print('└─────────────────────────────────────────────────────────────');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('┌─────────────────────────────────────────────────────────────');
    print('│ ❌ ERROR: ${err.type} ${err.requestOptions.uri}');
    print('│ Message: ${err.message}');
    if (err.response != null) {
      print('│ Status: ${err.response?.statusCode}');
      print('│ Data: ${err.response?.data}');
    }
    print('└─────────────────────────────────────────────────────────────');
    super.onError(err, handler);
  }
}
