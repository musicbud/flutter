import 'package:equatable/equatable.dart';

class SearchResults extends Equatable {
  final List<SearchItem> items;
  final List<String> suggestions;
  final SearchMetadata metadata;

  const SearchResults({
    required this.items,
    required this.suggestions,
    required this.metadata,
  });

  factory SearchResults.empty() {
    return SearchResults(
      items: const [],
      suggestions: const [],
      metadata: SearchMetadata.empty(),
    );
  }

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      items: (json['items'] as List)
          .map((item) => SearchItem.fromJson(item))
          .toList(),
      suggestions: List<String>.from(json['suggestions'] ?? []),
      metadata: SearchMetadata.fromJson(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
        'suggestions': suggestions,
        'metadata': metadata.toJson(),
      };

  @override
  List<Object?> get props => [items, suggestions, metadata];
}

class SearchItem extends Equatable {
  final String id;
  final String type;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Map<String, dynamic> data;
  final double relevanceScore;

  const SearchItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.data,
    required this.relevanceScore,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: json['image_url'],
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      relevanceScore: json['relevance_score']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'subtitle': subtitle,
        'image_url': imageUrl,
        'data': data,
        'relevance_score': relevanceScore,
      };

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        subtitle,
        imageUrl,
        data,
        relevanceScore,
      ];
}

class SearchMetadata extends Equatable {
  final int totalResults;
  final int pageSize;
  final int currentPage;
  final bool hasMore;
  final Map<String, int> typeCounts;
  final Duration searchTime;

  const SearchMetadata({
    required this.totalResults,
    required this.pageSize,
    required this.currentPage,
    required this.hasMore,
    required this.typeCounts,
    required this.searchTime,
  });

  factory SearchMetadata.empty() {
    return const SearchMetadata(
      totalResults: 0,
      pageSize: 0,
      currentPage: 0,
      hasMore: false,
      typeCounts: {},
      searchTime: Duration.zero,
    );
  }

  factory SearchMetadata.fromJson(Map<String, dynamic> json) {
    return SearchMetadata(
      totalResults: json['total_results'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      hasMore: json['has_more'] ?? false,
      typeCounts: Map<String, int>.from(json['type_counts'] ?? {}),
      searchTime: Duration(microseconds: json['search_time_us'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_results': totalResults,
        'page_size': pageSize,
        'current_page': currentPage,
        'has_more': hasMore,
        'type_counts': typeCounts,
        'search_time_us': searchTime.inMicroseconds,
      };

  @override
  List<Object?> get props => [
        totalResults,
        pageSize,
        currentPage,
        hasMore,
        typeCounts,
        searchTime,
      ];
}
