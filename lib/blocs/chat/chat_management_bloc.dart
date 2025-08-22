import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/chat_management_repository.dart';

// Events
abstract class ChatManagementEvent extends Equatable {
  const ChatManagementEvent();

  @override
  List<Object?> get props => [];
}

class GetChatHome extends ChatManagementEvent {}

class GetChatUsers extends ChatManagementEvent {}

class GetChatChannels extends ChatManagementEvent {}

class GetUserChat extends ChatManagementEvent {
  final String username;

  const GetUserChat({required this.username});

  @override
  List<Object?> get props => [username];
}

class GetChannelChat extends ChatManagementEvent {
  final String channelId;

  const GetChannelChat({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class SendMessage extends ChatManagementEvent {
  final String message;
  final String? channelId;
  final String? username;

  const SendMessage({
    required this.message,
    this.channelId,
    this.username,
  });

  @override
  List<Object?> get props => [message, channelId, username];
}

class CreateChannel extends ChatManagementEvent {
  final Map<String, dynamic> channelData;

  const CreateChannel({required this.channelData});

  @override
  List<Object?> get props => [channelData];
}

class GetChannelDashboard extends ChatManagementEvent {
  final String channelId;

  const GetChannelDashboard({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

class AddChannelMember extends ChatManagementEvent {
  final String channelId;
  final String username;

  const AddChannelMember({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class AcceptUserInvitation extends ChatManagementEvent {
  final String channelId;
  final String username;

  const AcceptUserInvitation({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class KickUser extends ChatManagementEvent {
  final String channelId;
  final String username;

  const KickUser({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class BlockUser extends ChatManagementEvent {
  final String channelId;
  final String username;

  const BlockUser({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class AddModerator extends ChatManagementEvent {
  final String channelId;
  final String username;

  const AddModerator({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class DeleteMessage extends ChatManagementEvent {
  final String messageId;
  final String channelId;

  const DeleteMessage({
    required this.messageId,
    required this.channelId,
  });

  @override
  List<Object?> get props => [messageId, channelId];
}

class HandleInvitation extends ChatManagementEvent {
  final String channelId;
  final String username;
  final bool accept;

  const HandleInvitation({
    required this.channelId,
    required this.username,
    required this.accept,
  });

  @override
  List<Object?> get props => [channelId, username, accept];
}

// States
abstract class ChatManagementState extends Equatable {
  const ChatManagementState();

  @override
  List<Object?> get props => [];
}

class ChatManagementInitial extends ChatManagementState {}

class ChatManagementLoading extends ChatManagementState {}

class ChatHomeLoaded extends ChatManagementState {
  final Map<String, dynamic> chatHome;

  const ChatHomeLoaded({required this.chatHome});

  @override
  List<Object?> get props => [chatHome];
}

class ChatUsersLoaded extends ChatManagementState {
  final List<dynamic> users;

  const ChatUsersLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class ChatChannelsLoaded extends ChatManagementState {
  final List<dynamic> channels;

  const ChatChannelsLoaded({required this.channels});

  @override
  List<Object?> get props => [channels];
}

class UserChatLoaded extends ChatManagementState {
  final List<dynamic> messages;
  final String username;

  const UserChatLoaded({
    required this.messages,
    required this.username,
  });

  @override
  List<Object?> get props => [messages, username];
}

class ChannelChatLoaded extends ChatManagementState {
  final List<dynamic> messages;
  final String channelId;

  const ChannelChatLoaded({
    required this.messages,
    required this.channelId,
  });

  @override
  List<Object?> get props => [messages, channelId];
}

class MessageSent extends ChatManagementState {
  final Map<String, dynamic> message;

  const MessageSent({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChannelCreated extends ChatManagementState {
  final Map<String, dynamic> channel;

  const ChannelCreated({required this.channel});

  @override
  List<Object?> get props => [channel];
}

class ChannelDashboardLoaded extends ChatManagementState {
  final Map<String, dynamic> dashboard;
  final String channelId;

  const ChannelDashboardLoaded({
    required this.dashboard,
    required this.channelId,
  });

  @override
  List<Object?> get props => [dashboard, channelId];
}

class ChannelMemberAdded extends ChatManagementState {
  final String channelId;
  final String username;

  const ChannelMemberAdded({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class UserInvitationAccepted extends ChatManagementState {
  final String channelId;
  final String username;

  const UserInvitationAccepted({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class UserKicked extends ChatManagementState {
  final String channelId;
  final String username;

  const UserKicked({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class UserBlocked extends ChatManagementState {
  final String channelId;
  final String username;

  const UserBlocked({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class ModeratorAdded extends ChatManagementState {
  final String channelId;
  final String username;

  const ModeratorAdded({
    required this.channelId,
    required this.username,
  });

  @override
  List<Object?> get props => [channelId, username];
}

class MessageDeleted extends ChatManagementState {
  final String messageId;
  final String channelId;

  const MessageDeleted({
    required this.messageId,
    required this.channelId,
  });

  @override
  List<Object?> get props => [messageId, channelId];
}

class InvitationHandled extends ChatManagementState {
  final String channelId;
  final String username;
  final bool accepted;

  const InvitationHandled({
    required this.channelId,
    required this.username,
    required this.accepted,
  });

  @override
  List<Object?> get props => [channelId, username, accepted];
}

class ChatManagementError extends ChatManagementState {
  final String message;

  const ChatManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ChatManagementBloc extends Bloc<ChatManagementEvent, ChatManagementState> {
  final ChatManagementRepository _chatManagementRepository;

  ChatManagementBloc({required ChatManagementRepository chatManagementRepository})
      : _chatManagementRepository = chatManagementRepository,
        super(ChatManagementInitial()) {
    on<GetChatHome>(_onGetChatHome);
    on<GetChatUsers>(_onGetChatUsers);
    on<GetChatChannels>(_onGetChatChannels);
    on<GetUserChat>(_onGetUserChat);
    on<GetChannelChat>(_onGetChannelChat);
    on<SendMessage>(_onSendMessage);
    on<CreateChannel>(_onCreateChannel);
    on<GetChannelDashboard>(_onGetChannelDashboard);
    on<AddChannelMember>(_onAddChannelMember);
    on<AcceptUserInvitation>(_onAcceptUserInvitation);
    on<KickUser>(_onKickUser);
    on<BlockUser>(_onBlockUser);
    on<AddModerator>(_onAddModerator);
    on<DeleteMessage>(_onDeleteMessage);
    on<HandleInvitation>(_onHandleInvitation);
  }

  Future<void> _onGetChatHome(
    GetChatHome event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      final chatHome = await _chatManagementRepository.getChatHome();
      emit(ChatHomeLoaded(chatHome: chatHome));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onGetChatUsers(
    GetChatUsers event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      final users = await _chatManagementRepository.getChatUsers();
      emit(ChatUsersLoaded(users: users));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onGetChatChannels(
    GetChatChannels event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      final channels = await _chatManagementRepository.getChatChannels();
      emit(ChatChannelsLoaded(channels: channels));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onGetUserChat(
    GetUserChat event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      final messages = await _chatManagementRepository.getUserChat(event.username);
      emit(UserChatLoaded(messages: messages, username: event.username));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onGetChannelChat(
    GetChannelChat event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      final messages = await _chatManagementRepository.getChannelChat(event.channelId);
      emit(ChannelChatLoaded(messages: messages, channelId: event.channelId));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      final message = await _chatManagementRepository.sendMessage(
        event.message,
        event.channelId,
        event.username,
      );
      emit(MessageSent(message: message));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onCreateChannel(
    CreateChannel event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      final channel = await _chatManagementRepository.createChannel(event.channelData);
      emit(ChannelCreated(channel: channel));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onGetChannelDashboard(
    GetChannelDashboard event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      final dashboard = await _chatManagementRepository.getChannelDashboard(event.channelId);
      emit(ChannelDashboardLoaded(dashboard: dashboard, channelId: event.channelId));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onAddChannelMember(
    AddChannelMember event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      await _chatManagementRepository.addChannelMember(event.channelId, event.username);
      emit(ChannelMemberAdded(channelId: event.channelId, username: event.username));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onAcceptUserInvitation(
    AcceptUserInvitation event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      await _chatManagementRepository.acceptUserInvitation(event.channelId, event.username);
      emit(UserInvitationAccepted(channelId: event.channelId, username: event.username));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onKickUser(
    KickUser event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      await _chatManagementRepository.kickUser(event.channelId, event.username);
      emit(UserKicked(channelId: event.channelId, username: event.username));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onBlockUser(
    BlockUser event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      await _chatManagementRepository.blockUser(event.channelId, event.username);
      emit(UserBlocked(channelId: event.channelId, username: event.username));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onAddModerator(
    AddModerator event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      await _chatManagementRepository.addModerator(event.channelId, event.username);
      emit(ModeratorAdded(channelId: event.channelId, username: event.username));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      await _chatManagementRepository.deleteMessage(event.messageId, event.channelId);
      emit(MessageDeleted(messageId: event.messageId, channelId: event.channelId));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }

  Future<void> _onHandleInvitation(
    HandleInvitation event,
    Emitter<ChatManagementState> emit,
  ) async {
    try {
      emit(ChatManagementLoading());
      await _chatManagementRepository.handleInvitation(
        event.channelId,
        event.username,
        event.accept,
      );
      emit(InvitationHandled(
        channelId: event.channelId,
        username: event.username,
        accepted: event.accept,
      ));
    } catch (e) {
      emit(ChatManagementError(e.toString()));
    }
  }
}