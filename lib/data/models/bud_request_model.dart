import '../../domain/models/bud_request.dart';

class BudRequestModel extends BudRequest {
  const BudRequestModel({
    required super.id,
    required super.senderId,
    required super.recipientId,
    required super.createdAt,
    required super.status,
  });

  factory BudRequestModel.fromJson(Map<String, dynamic> json) {
    return BudRequestModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      recipientId: json['recipient_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'recipient_id': recipientId,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
