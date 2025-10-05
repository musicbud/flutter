import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();

  @override
  List<Object?> get props => [];
}

class CommonTopGenresRequested extends GenreEvent {
  final String username;

  const CommonTopGenresRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonGenresRequested extends GenreEvent {
  final String budUid;

  const CommonGenresRequested(this.budUid);

  @override
  List<Object> get props => [budUid];
}
