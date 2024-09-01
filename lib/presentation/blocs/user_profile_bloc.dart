import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';

// Events
abstract class UserProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserProfileEvent {}

// States
abstract class UserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile userProfile;

  UserProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository userRepository;

  UserProfileBloc(this.userRepository) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(LoadUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final userProfile = await userRepository.getUserProfile();
      emit(UserProfileLoaded(userProfile));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}
