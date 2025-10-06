import '../../models/bud_response.dart';

class BudResponseModel extends BudResponse {
  const BudResponseModel({
    required super.id,
    required super.requestId,
    required super.responderId,
    required super.status,
    required super.createdAt,
  });

  factory BudResponseModel.fromJson(Map<String, dynamic> json) {
    return BudResponseModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      responderId: json['responder_id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts this [BudResponseModel] to a JSON map
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'responder_id': responderId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
