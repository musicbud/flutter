import 'package:equatable/equatable.dart';
import '../../models/chat.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<Chat> chats;

  const ChatsLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

class ChatMessageReceivedState extends ChatsState {
  final Chat chat;

  const ChatMessageReceivedState({required this.chat});

  @override
  List<Object> get props => [chat];
}

class ChatReadState extends ChatsState {
  final String userId;

  const ChatReadState({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ChatArchivedState extends ChatsState {
  final String userId;

  const ChatArchivedState({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ChatDeletedState extends ChatsState {
  final String userId;

  const ChatDeletedState({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ChatsFailure extends ChatsState {
  final String error;

  const ChatsFailure({required this.error});

  @override
  List<Object> get props => [error];
}
