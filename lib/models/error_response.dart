class ErrorResponse {
  final String message;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? details;

  const ErrorResponse({
    required this.message,
    this.error,
    this.statusCode,
    this.details,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] as String? ?? 'An error occurred',
      error: json['error'] as String?,
      statusCode: json['status_code'] as int?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (error != null) 'error': error,
      if (statusCode != null) 'status_code': statusCode,
      if (details != null) 'details': details,
    };
  }

  @override
  String toString() {
    return 'ErrorResponse(message: $message, error: $error, statusCode: $statusCode)';
  }
}