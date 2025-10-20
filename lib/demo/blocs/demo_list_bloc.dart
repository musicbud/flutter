import 'package:flutter_bloc/flutter_bloc.dart';

// Model
class DemoItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;

  DemoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

// Events
abstract class DemoListEvent {}

class LoadDemoList extends DemoListEvent {}

class RefreshDemoList extends DemoListEvent {}

class LoadMoreDemoItems extends DemoListEvent {}

// States
abstract class DemoListState {
  final List<DemoItem> items;
  DemoListState({this.items = const []});
}

class DemoListInitial extends DemoListState {}

class DemoListLoading extends DemoListState {
  DemoListLoading({super.items});
}

class DemoListLoaded extends DemoListState {
  DemoListLoaded({required super.items});
}

class DemoListError extends DemoListState {
  final String message;
  DemoListError({required this.message, super.items});
}

// BLoC
class DemoListBloc extends Bloc<DemoListEvent, DemoListState> {
  DemoListBloc() : super(DemoListInitial()) {
    on<LoadDemoList>(_onLoadDemoList);
    on<RefreshDemoList>(_onRefreshDemoList);
    on<LoadMoreDemoItems>(_onLoadMoreDemoItems);
  }

  List<DemoItem> _generateItems(int count, {int offset = 0}) {
    return List.generate(
      count,
      (index) => DemoItem(
        id: '${offset + index}',
        title: 'Item ${offset + index + 1}',
        subtitle: 'This is demo item number ${offset + index + 1}',
        imageUrl: 'https://picsum.photos/200?random=${offset + index}',
      ),
    );
  }

  Future<void> _onLoadDemoList(
    LoadDemoList event,
    Emitter<DemoListState> emit,
  ) async {
    emit(DemoListLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final items = _generateItems(15);
    emit(DemoListLoaded(items: items));
  }

  Future<void> _onRefreshDemoList(
    RefreshDemoList event,
    Emitter<DemoListState> emit,
  ) async {
    final currentItems = state.items;
    emit(DemoListLoading(items: currentItems));

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    final items = _generateItems(15);
    emit(DemoListLoaded(items: items));
  }

  Future<void> _onLoadMoreDemoItems(
    LoadMoreDemoItems event,
    Emitter<DemoListState> emit,
  ) async {
    final currentItems = state.items;

    // Simulate loading more
    await Future.delayed(const Duration(milliseconds: 800));

    final moreItems = _generateItems(10, offset: currentItems.length);
    emit(DemoListLoaded(items: [...currentItems, ...moreItems]));
  }
}
