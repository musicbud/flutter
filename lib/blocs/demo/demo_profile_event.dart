import 'package:equatable/equatable.dart';

abstract class DemoProfileEvent extends Equatable {
  const DemoProfileEvent();

  @override
  List<Object?> get props => [];
}

class DemoProfileRequested extends DemoProfileEvent {
  const DemoProfileRequested();
}

class DemoProfileUpdated extends DemoProfileEvent {
  final Map<String, dynamic> data;

  const DemoProfileUpdated(this.data);

  @override
  List<Object> get props => [data];
}

class DemoPreferencesUpdated extends DemoProfileEvent {
  final Map<String, dynamic> preferences;

  const DemoPreferencesUpdated(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class DemoInterestsUpdated extends DemoProfileEvent {
  final List<String> interests;

  const DemoInterestsUpdated(this.interests);

  @override
  List<Object> get props => [interests];
}

class DemoPremiumToggled extends DemoProfileEvent {
  const DemoPremiumToggled();
}

class DemoBadgesUpdated extends DemoProfileEvent {
  final List<String> badges;

  const DemoBadgesUpdated(this.badges);

  @override
  List<Object> get props => [badges];
}

class DemoStatsRequested extends DemoProfileEvent {
  const DemoStatsRequested();
}
