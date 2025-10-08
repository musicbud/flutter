import 'package:equatable/equatable.dart';

/// A model class representing a service login URL response
class ServiceLoginResponse extends Equatable {
  final String message;
  final int code;
  final String status;
  final ServiceLoginData data;

  const ServiceLoginResponse({
    required this.message,
    required this.code,
    required this.status,
    required this.data,
  });

  /// Creates a [ServiceLoginResponse] from a JSON map
  factory ServiceLoginResponse.fromJson(Map<String, dynamic> json) {
    return ServiceLoginResponse(
      message: json['message'] as String,
      code: json['code'] as int,
      status: json['status'] as String,
      data: ServiceLoginData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Converts this [ServiceLoginResponse] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'status': status,
      'data': data.toJson(),
    };
  }

  /// Creates a copy of this [ServiceLoginResponse] with the given fields replaced with new values
  ServiceLoginResponse copyWith({
    String? message,
    int? code,
    String? status,
    ServiceLoginData? data,
  }) {
    return ServiceLoginResponse(
      message: message ?? this.message,
      code: code ?? this.code,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [message, code, status, data];
}

/// A model class representing the data portion of a service login response
class ServiceLoginData extends Equatable {
  final String authorizationLink;

  const ServiceLoginData({
    required this.authorizationLink,
  });

  /// Creates a [ServiceLoginData] from a JSON map
  factory ServiceLoginData.fromJson(Map<String, dynamic> json) {
    return ServiceLoginData(
      authorizationLink: json['authorization_link'] as String,
    );
  }

  /// Converts this [ServiceLoginData] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'authorization_link': authorizationLink,
    };
  }

  /// Creates a copy of this [ServiceLoginData] with the given fields replaced with new values
  ServiceLoginData copyWith({
    String? authorizationLink,
  }) {
    return ServiceLoginData(
      authorizationLink: authorizationLink ?? this.authorizationLink,
    );
  }

  @override
  List<Object?> get props => [authorizationLink];
}