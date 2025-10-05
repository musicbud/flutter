import 'package:equatable/equatable.dart';

abstract class CommonItemsEvent extends Equatable {
  const CommonItemsEvent();

  @override
  List<Object?> get props => [];
}

class CommonItemsRequested extends CommonItemsEvent {
  final int page;

  const CommonItemsRequested({this.page = 1});

  @override
  List<Object> get props => [page];
}

class CommonItemsLoadMoreRequested extends CommonItemsEvent {}

class CommonItemsRefreshRequested extends CommonItemsEvent {}

class CommonItemsSearchRequested extends CommonItemsEvent {
  final String query;

  const CommonItemsSearchRequested(this.query);

  @override
  List<Object> get props => [query];
}
