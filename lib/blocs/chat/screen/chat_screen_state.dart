import 'package:equatable/equatable.dart';
import '../../../domain/models/message.dart';

abstract class ChatScreenState extends Equatable {
  const ChatScreenState();

  @override
  List<Object?> get props => [];
}

class ChatScreenInitial extends ChatScreenState {}

class ChatScreenLoading extends ChatScreenState {}

class ChatScreenLoaded extends ChatScreenState {
  final List<Message> messages;
  final bool isTyping;

  const ChatScreenLoaded(this.messages, {this.isTyping = false});

  @override
  List<Object> get props => [messages, isTyping];
}

class ChatScreenMessageSentState extends ChatScreenState {
  final Message message;

  const ChatScreenMessageSentState(this.message);

  @override
  List<Object> get props => [message];
}

class ChatScreenTypingState extends ChatScreenState {
  final String userId;

  const ChatScreenTypingState(this.userId);

  @override
  List<Object> get props => [userId];
}

class ChatScreenTypingStoppedState extends ChatScreenState {
  final String userId;

  const ChatScreenTypingStoppedState(this.userId);

  @override
  List<Object> get props => [userId];
}

class ChatScreenFailure extends ChatScreenState {
  final String error;

  const ChatScreenFailure(this.error);

  @override
  List<Object> get props => [error];
}
