import 'package:equatable/equatable.dart';
import '../../domain/models/demo_user_profile.dart';

abstract class DemoProfileState extends Equatable {
  const DemoProfileState();

  @override
  List<Object?> get props => [];
}

class DemoProfileInitial extends DemoProfileState {
  const DemoProfileInitial();
}

class DemoProfileLoading extends DemoProfileState {
  const DemoProfileLoading();
}

class DemoProfileLoaded extends DemoProfileState {
  final DemoUserProfile profile;
  final bool isEditing;
  final Map<String, int> stats;

  const DemoProfileLoaded({
    required this.profile,
    this.isEditing = false,
    this.stats = const {},
  });

  @override
  List<Object> get props => [profile, isEditing, stats];

  DemoProfileLoaded copyWith({
    DemoUserProfile? profile,
    bool? isEditing,
    Map<String, int>? stats,
  }) {
    return DemoProfileLoaded(
      profile: profile ?? this.profile,
      isEditing: isEditing ?? this.isEditing,
      stats: stats ?? this.stats,
    );
  }
}

class DemoProfileError extends DemoProfileState {
  final String message;

  const DemoProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class DemoProfileUpdating extends DemoProfileState {
  final DemoUserProfile currentProfile;

  const DemoProfileUpdating(this.currentProfile);

  @override
  List<Object> get props => [currentProfile];
}

class DemoProfileUpdateSuccess extends DemoProfileState {
  final DemoUserProfile profile;
  final String message;

  const DemoProfileUpdateSuccess({
    required this.profile,
    required this.message,
  });

  @override
  List<Object> get props => [profile, message];
}
