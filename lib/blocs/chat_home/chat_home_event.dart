import 'package:equatable/equatable.dart';

abstract class ChatHomeEvent extends Equatable {
  const ChatHomeEvent();

  @override
  List<Object> get props => [];
}

class ChatHomeInitialized extends ChatHomeEvent {}

class ChatHomeTabChanged extends ChatHomeEvent {
  final int tabIndex;

  const ChatHomeTabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class ChatHomeRefreshRequested extends ChatHomeEvent {}
