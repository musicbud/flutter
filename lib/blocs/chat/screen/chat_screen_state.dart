import 'package:equatable/equatable.dart';
import '../../../models/message.dart';

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
  final String? typingUserId;

  const ChatScreenLoaded({
    required this.messages,
    this.isTyping = false,
    this.typingUserId,
  });

  @override
  List<Object?> get props => [messages, isTyping, typingUserId];

  ChatScreenLoaded copyWith({
    List<Message>? messages,
    bool? isTyping,
    String? typingUserId,
  }) {
    return ChatScreenLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      typingUserId: typingUserId ?? this.typingUserId,
    );
  }
}

class ChatScreenMessageSendSuccess extends ChatScreenState {
  final Message message;

  const ChatScreenMessageSendSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ChatScreenMessageReceiveSuccess extends ChatScreenState {
  final Message message;

  const ChatScreenMessageReceiveSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ChatScreenTypingStatus extends ChatScreenState {
  final String userId;
  final bool isTyping;

  const ChatScreenTypingStatus({
    required this.userId,
    required this.isTyping,
  });

  @override
  List<Object> get props => [userId, isTyping];
}

class ChatScreenFailure extends ChatScreenState {
  final String error;

  const ChatScreenFailure(this.error);

  @override
  List<Object> get props => [error];
}
