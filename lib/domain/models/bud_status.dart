import 'package:equatable/equatable.dart';

class BudStatus extends Equatable {
  final String userId;
  final String status;
  final DateTime lastActive;
  final bool isOnline;

  const BudStatus({
    required this.userId,
    required this.status,
    required this.lastActive,
    required this.isOnline,
  });

  factory BudStatus.fromJson(Map<String, dynamic> json) {
    return BudStatus(
      userId: json['user_id'] as String,
      status: json['status'] as String,
      lastActive: DateTime.parse(json['last_active'] as String),
      isOnline: json['is_online'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'status': status,
      'last_active': lastActive.toIso8601String(),
      'is_online': isOnline,
    };
  }

  @override
  List<Object?> get props => [userId, status, lastActive, isOnline];
}
