import 'package:equatable/equatable.dart';

class BudRequest extends Equatable {
  final String id;
  final String senderId;
  final String recipientId;
  final DateTime createdAt;
  final String status;

  const BudRequest({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.createdAt,
    required this.status,
  });

  factory BudRequest.fromJson(Map<String, dynamic> json) {
    return BudRequest(
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

  @override
  List<Object?> get props => [id, senderId, recipientId, createdAt, status];
}
