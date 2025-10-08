import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../models/user_profile.dart';

// Events
abstract class SimpleProfileEvent extends Equatable {
  const SimpleProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadSimpleProfile extends SimpleProfileEvent {}

// States
abstract class SimpleProfileState extends Equatable {
  const SimpleProfileState();

  @override
  List<Object> get props => [];
}

class SimpleProfileInitial extends SimpleProfileState {}

class SimpleProfileLoading extends SimpleProfileState {}

class SimpleProfileLoaded extends SimpleProfileState {
  final UserProfile userProfile;

  const SimpleProfileLoaded(this.userProfile);

  @override
  List<Object> get props => [userProfile];
}

class SimpleProfileError extends SimpleProfileState {
  final String message;

  const SimpleProfileError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class SimpleProfileBloc extends Bloc<SimpleProfileEvent, SimpleProfileState> {
  final UserRepository userRepository;

  SimpleProfileBloc(this.userRepository) : super(SimpleProfileInitial()) {
    on<LoadSimpleProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(LoadSimpleProfile event, Emitter<SimpleProfileState> emit) async {
    emit(SimpleProfileLoading());
    try {
      final userProfile = await userRepository.getUserProfile();
      emit(SimpleProfileLoaded(userProfile));
    } catch (e) {
      emit(SimpleProfileError(e.toString()));
    }
  }
}