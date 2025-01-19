class ServerStatus {
  final bool isReachable;
  final String? error;
  final String? message;

  ServerStatus({
    required this.isReachable,
    this.error,
    this.message,
  });

  factory ServerStatus.fromJson(Map<String, dynamic> json) {
    return ServerStatus(
      isReachable: json['isReachable'] as bool,
      error: json['error'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isReachable': isReachable,
      'error': error,
      'message': message,
    };
  }
}
