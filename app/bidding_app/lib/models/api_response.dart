/// API Error Response Model
class ApiError {
  final String message;
  final int? statusCode;
  final String? error;

  ApiError({
    required this.message,
    this.statusCode,
    this.error,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    // Handle error field - it can be a String, Map, or null
    String? errorString;
    if (json['error'] != null) {
      if (json['error'] is String) {
        errorString = json['error'];
      } else if (json['error'] is Map) {
        // Convert error object to string representation
        errorString = json['error'].toString();
      }
    }
    
    return ApiError(
      message: json['message'] ?? 'An error occurred',
      statusCode: json['statusCode'] ?? json['error']?['statusCode'],
      error: errorString,
    );
  }

  @override
  String toString() => message;
}

/// Generic API Response wrapper
class ApiResponse<T> {
  final T? data;
  final ApiError? error;
  final bool success;

  ApiResponse({
    this.data,
    this.error,
    required this.success,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(
      data: data,
      success: true,
    );
  }

  factory ApiResponse.failure(ApiError error) {
    return ApiResponse(
      error: error,
      success: false,
    );
  }
}
