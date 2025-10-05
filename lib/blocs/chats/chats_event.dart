import 'package:equatable/equatable.dart';

abstract class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class ChatsRequested extends ChatsEvent {
  const ChatsRequested();
}

class ChatMessageReceived extends ChatsEvent {
  final String userId;
  final String message;
  final DateTime timestamp;

  const ChatMessageReceived({
    required this.userId,
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object> get props => [userId, message, timestamp];
}

class ChatRead extends ChatsEvent {
  final String userId;

  const ChatRead({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ChatArchived extends ChatsEvent {
  final String userId;

  const ChatArchived({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ChatDeleted extends ChatsEvent {
  final String userId;

  const ChatDeleted({required this.userId});

  @override
  List<Object> get props => [userId];
}
