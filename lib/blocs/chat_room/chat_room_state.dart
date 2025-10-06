import 'package:equatable/equatable.dart';
import '../../models/message.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();

  @override
  List<Object?> get props => [];
}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final List<Message> messages;

  const ChatRoomLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatRoomMessageSentSuccess extends ChatRoomState {}

class ChatRoomMessageDeletedSuccess extends ChatRoomState {}

class ChatRoomFailure extends ChatRoomState {
  final String error;

  const ChatRoomFailure(this.error);

  @override
  List<Object> get props => [error];
}
