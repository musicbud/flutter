import 'package:equatable/equatable.dart';
import 'common_item.dart';

/// A model class representing a standardized response for common content endpoints
class CommonContentResponse extends Equatable {
  final String message;
  final int code;
  final bool successful;
  final CommonContentData data;

  const CommonContentResponse({
    required this.message,
    required this.code,
    required this.successful,
    required this.data,
  });

  /// Creates a [CommonContentResponse] from a JSON map
  factory CommonContentResponse.fromJson(Map<String, dynamic> json) {
    return CommonContentResponse(
      message: json['message'] as String,
      code: json['code'] as int,
      successful: json['successful'] as bool,
      data: CommonContentData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Converts this [CommonContentResponse] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'successful': successful,
      'data': data.toJson(),
    };
  }

  /// Creates a copy of this [CommonContentResponse] with the given fields replaced with new values
  CommonContentResponse copyWith({
    String? message,
    int? code,
    bool? successful,
    CommonContentData? data,
  }) {
    return CommonContentResponse(
      message: message ?? this.message,
      code: code ?? this.code,
      successful: successful ?? this.successful,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [message, code, successful, data];
}

/// A model class representing the data portion of a common content response
class CommonContentData extends Equatable {
  final List<CommonItem> commonItems;

  const CommonContentData({
    required this.commonItems,
  });

  /// Creates a [CommonContentData] from a JSON map
  factory CommonContentData.fromJson(Map<String, dynamic> json) {
    return CommonContentData(
      commonItems: (json['common_items'] as List<dynamic>?)
              ?.map((e) => CommonItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Converts this [CommonContentData] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'common_items': commonItems.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a copy of this [CommonContentData] with the given fields replaced with new values
  CommonContentData copyWith({
    List<CommonItem>? commonItems,
  }) {
    return CommonContentData(
      commonItems: commonItems ?? this.commonItems,
    );
  }

  @override
  List<Object?> get props => [commonItems];
}