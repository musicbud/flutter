import '../../domain/models/bud_status.dart';

class BudStatusModel extends BudStatus {
  const BudStatusModel({
    required super.userId,
    required super.status,
    required super.lastActive,
    required super.isOnline,
  });

  factory BudStatusModel.fromJson(Map<String, dynamic> json) {
    return BudStatusModel(
      userId: json['user_id'] as String,
      status: json['status'] as String,
      lastActive: DateTime.parse(json['last_active'] as String),
      isOnline: json['is_online'] as bool,
    );
  }

  /// Converts this [BudStatusModel] to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'status': status,
      'last_active': lastActive.toIso8601String(),
      'is_online': isOnline,
    };
  }
}
