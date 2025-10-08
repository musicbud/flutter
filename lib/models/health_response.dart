import 'package:equatable/equatable.dart';

/// A model class representing a health check response
class HealthResponse extends Equatable {
  final String message;
  final int code;
  final String status;
  final Map<String, dynamic> data;

  const HealthResponse({
    required this.message,
    required this.code,
    required this.status,
    required this.data,
  });

  /// Creates a [HealthResponse] from a JSON map
  factory HealthResponse.fromJson(Map<String, dynamic> json) {
    return HealthResponse(
      message: json['message'] as String,
      code: json['code'] as int,
      status: json['status'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts this [HealthResponse] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'status': status,
      'data': data,
    };
  }

  /// Creates a copy of this [HealthResponse] with the given fields replaced with new values
  HealthResponse copyWith({
    String? message,
    int? code,
    String? status,
    Map<String, dynamic>? data,
  }) {
    return HealthResponse(
      message: message ?? this.message,
      code: code ?? this.code,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [message, code, status, data];
}