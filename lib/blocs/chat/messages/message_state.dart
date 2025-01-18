import 'package:equatable/equatable.dart';
import '../../../models/message.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageFailure extends MessageState {
  final String error;

  const MessageFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChannelMessagesLoaded extends MessageState {
  final List<Message> messages;

  const ChannelMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSentSuccess extends MessageState {
  final Message message;

  const MessageSentSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class MessageDeletedSuccess extends MessageState {}

class DirectMessagesLoaded extends MessageState {
  final List<Message> messages;

  const DirectMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class DirectMessageSentSuccess extends MessageState {
  final Message message;

  const DirectMessageSentSuccess(this.message);

  @override
  List<Object> get props => [message];
}
