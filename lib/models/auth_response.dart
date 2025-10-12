class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int? expiresIn;
  final String? userId;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
    this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String? ?? json['access'] as String,
      refreshToken: json['refresh_token'] as String? ?? json['refresh'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int?,
      userId: json['user_id'] as String? ?? (json['user']?['id']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      if (expiresIn != null) 'expires_in': expiresIn,
      if (userId != null) 'user_id': userId,
    };
  }
}

class RegisterResponse {
  final String message;
  final String? userId;
  final bool success;

  const RegisterResponse({
    required this.message,
    this.userId,
    this.success = true,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String? ?? 'Registration successful',
      userId: json['user_id'] as String?,
      success: json['success'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      if (userId != null) 'user_id': userId,
    };
  }
}

class TokenRefreshResponse {
  final String accessToken;
  final String tokenType;
  final int? expiresIn;

  const TokenRefreshResponse({
    required this.accessToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
  });

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    return TokenRefreshResponse(
      accessToken: json['access_token'] as String? ?? json['access'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      if (expiresIn != null) 'expires_in': expiresIn,
    };
  }
}