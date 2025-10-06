import 'package:equatable/equatable.dart';
import '../../../models/message.dart';
import '../../../models/user_profile.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();

  @override
  List<Object?> get props => [];
}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final List<Message> messages;
  final List<Message>? previousMessages;

  const ChatRoomLoaded({
    required this.messages,
    this.previousMessages,
  });

  @override
  List<Object?> get props => [messages, previousMessages];
}

class ChatRoomMessageSentSuccess extends ChatRoomState {
  final Message message;

  const ChatRoomMessageSentSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatRoomMessageDeletedSuccess extends ChatRoomState {}

class ChatRoomMessageEditedSuccess extends ChatRoomState {}

class ChatRoomTypingStartedState extends ChatRoomState {
  final String username;

  const ChatRoomTypingStartedState({required this.username});

  @override
  List<Object?> get props => [username];
}

class ChatRoomTypingStoppedState extends ChatRoomState {
  final String username;

  const ChatRoomTypingStoppedState({required this.username});

  @override
  List<Object?> get props => [username];
}

class ChatRoomReactionAddedSuccess extends ChatRoomState {}

class ChatRoomReactionRemovedSuccess extends ChatRoomState {}

class ChatRoomMembersLoaded extends ChatRoomState {
  final List<UserProfile> members;

  const ChatRoomMembersLoaded({required this.members});

  @override
  List<Object?> get props => [members];
}

class ChatRoomDetailsLoaded extends ChatRoomState {
  final Map<String, dynamic> details;

  const ChatRoomDetailsLoaded({required this.details});

  @override
  List<Object?> get props => [details];
}

class ChatRoomJoinSuccess extends ChatRoomState {}

class ChatRoomLeaveSuccess extends ChatRoomState {}

class ChatRoomMuteSuccess extends ChatRoomState {}

class ChatRoomUnmuteSuccess extends ChatRoomState {}

class ChatRoomFailure extends ChatRoomState {
  final String error;

  const ChatRoomFailure(this.error);

  @override
  List<Object?> get props => [error];
}