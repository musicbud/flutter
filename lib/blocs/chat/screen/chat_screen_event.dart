import 'package:equatable/equatable.dart';
import '../../../domain/models/message.dart';

abstract class ChatScreenEvent extends Equatable {
  const ChatScreenEvent();

  @override
  List<Object?> get props => [];
}

class ChatScreenMessagesRequested extends ChatScreenEvent {
  final String userId;
  final int? limit;
  final String? before;

  const ChatScreenMessagesRequested(
    this.userId, {
    this.limit,
    this.before,
  });

  @override
  List<Object?> get props => [userId, limit, before];
}

class ChatScreenMessageSent extends ChatScreenEvent {
  final String userId;
  final String content;

  const ChatScreenMessageSent({
    required this.userId,
    required this.content,
  });

  @override
  List<Object> get props => [userId, content];
}

class ChatScreenMessageReceived extends ChatScreenEvent {
  final Message message;

  const ChatScreenMessageReceived(this.message);

  @override
  List<Object> get props => [message];
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
