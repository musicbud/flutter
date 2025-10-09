class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int perPage;
  final bool hasNext;
  final bool hasPrev;

  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.perPage,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int? ?? json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalCount: json['total_count'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 20,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrev: json['has_prev'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_count': totalCount,
      'per_page': perPage,
      'has_next': hasNext,
      'has_prev': hasPrev,
    };
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta pagination;

  const PaginatedResponse({
    required this.data,
    required this.pagination,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      pagination: PaginationMeta.fromJson(json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    return {
      'data': data.map(toJson).toList(),
      'pagination': pagination.toJson(),
    };
  }
}