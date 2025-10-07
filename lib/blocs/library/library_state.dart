import 'package:equatable/equatable.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<dynamic> items;
  final String currentType;
  final bool hasReachedEnd;
  final int totalCount;
  final String? error;

  const LibraryLoaded({
    required this.items,
    required this.currentType,
    this.hasReachedEnd = false,
    this.totalCount = 0,
    this.error,
  });

  @override
  List<Object?> get props => [items, currentType, hasReachedEnd, totalCount, error];

  LibraryLoaded copyWith({
    List<dynamic>? items,
    String? currentType,
    bool? hasReachedEnd,
    int? totalCount,
    String? error,
  }) {
    return LibraryLoaded(
      items: items ?? this.items,
      currentType: currentType ?? this.currentType,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      totalCount: totalCount ?? this.totalCount,
      error: error ?? this.error,
    );
  }
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError(this.message);

  @override
  List<Object> get props => [message];
}

class LibraryActionSuccess extends LibraryState {
  final String message;

  const LibraryActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class LibraryActionFailure extends LibraryState {
  final String error;

  const LibraryActionFailure(this.error);

  @override
  List<Object> get props => [error];
}
