import 'package:equatable/equatable.dart';

class BudResponse extends Equatable {
  final String id;
  final String requestId;
  final String responderId;
  final String status;
  final DateTime createdAt;

  const BudResponse({
    required this.id,
    required this.requestId,
    required this.responderId,
    required this.status,
    required this.createdAt,
  });

  factory BudResponse.fromJson(Map<String, dynamic> json) {
    return BudResponse(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      responderId: json['responder_id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'responder_id': responderId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, requestId, responderId, status, createdAt];
}
