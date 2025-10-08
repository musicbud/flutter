import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../models/user_profile.dart';

// Events
abstract class SimpleUserProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSimpleUserProfile extends SimpleUserProfileEvent {}

// States
abstract class SimpleUserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SimpleUserProfileInitial extends SimpleUserProfileState {}

class SimpleUserProfileLoading extends SimpleUserProfileState {}

class SimpleUserProfileLoaded extends SimpleUserProfileState {
  final UserProfile userProfile;

  SimpleUserProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class SimpleUserProfileError extends SimpleUserProfileState {
  final String message;

  SimpleUserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class SimpleUserProfileBloc extends Bloc<SimpleUserProfileEvent, SimpleUserProfileState> {
  final UserRepository userRepository;

  SimpleUserProfileBloc(this.userRepository) : super(SimpleUserProfileInitial()) {
    on<LoadSimpleUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(LoadSimpleUserProfile event, Emitter<SimpleUserProfileState> emit) async {
    emit(SimpleUserProfileLoading());
    try {
      final userProfile = await userRepository.getUserProfile();
      emit(SimpleUserProfileLoaded(userProfile));
    } catch (e) {
      emit(SimpleUserProfileError(e.toString()));
    }
  }
}