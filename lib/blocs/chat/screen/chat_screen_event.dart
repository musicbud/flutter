import 'package:equatable/equatable.dart';

abstract class ChatScreenEvent extends Equatable {
  const ChatScreenEvent();

  @override
  List<Object?> get props => [];
}

class ChatScreenMessagesRequested extends ChatScreenEvent {
  final String userId;

  const ChatScreenMessagesRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class ChatScreenMessageSent extends ChatScreenEvent {
  final String userId;
  final String message;

  const ChatScreenMessageSent({
    required this.userId,
    required this.message,
  });

  @override
  List<Object> get props => [userId, message];
}

class ChatScreenMessageReceived extends ChatScreenEvent {
  final String userId;
  final String message;

  const ChatScreenMessageReceived({
    required this.userId,
    required this.message,
  });

  @override
  List<Object> get props => [userId, message];
}

class ChatScreenTypingStarted extends ChatScreenEvent {
  final String userId;

  const ChatScreenTypingStarted(this.userId);

  @override
  List<Object> get props => [userId];
}

class ChatScreenTypingStopped extends ChatScreenEvent {
  final String userId;

  const ChatScreenTypingStopped(this.userId);

  @override
  List<Object> get props => [userId];
}
