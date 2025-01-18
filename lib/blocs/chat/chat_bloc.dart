import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../models/channel.dart';
import '../../models/channel_user.dart';
import '../../models/message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatInitial()) {
    on<ChatChannelListRequested>(_onChannelListRequested);
    on<ChatChannelUsersRequested>(_onChannelUsersRequested);
    on<ChatChannelMessagesRequested>(_onChannelMessagesRequested);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatMessageDeleted>(_onMessageDeleted);
    on<ChatChannelCreated>(_onChannelCreated);
    on<ChatChannelJoined>(_onChannelJoined);
    on<ChatChannelJoinRequested>(_onChannelJoinRequested);
    on<ChatChannelDetailsRequested>(_onChannelDetailsRequested);
    on<ChatChannelDashboardRequested>(_onChannelDashboardRequested);
    on<ChatChannelRolesChecked>(_onChannelRolesChecked);
    on<ChatAdminActionPerformed>(_onAdminActionPerformed);
    on<ChatChannelInvitationsRequested>(_onChannelInvitationsRequested);
    on<ChatChannelBlockedUsersRequested>(_onChannelBlockedUsersRequested);
    on<ChatUserInvitationsRequested>(_onUserInvitationsRequested);
    on<ChatUserMessagesRequested>(_onUserMessagesRequested);
    on<ChatUserMessageSent>(_onUserMessageSent);
  }

  Future<void> _onChannelListRequested(
    ChatChannelListRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final channels = await _chatRepository.getChannelList();
      emit(ChatChannelListLoaded(channels));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelUsersRequested(
    ChatChannelUsersRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final users = await _chatRepository.getChannelUsers(event.channelId);
      emit(ChatChannelUsersLoaded(
          users.entries.map((e) => ChannelUser.fromJson(e.value)).toList()));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelMessagesRequested(
    ChatChannelMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages =
          await _chatRepository.getChannelMessages(event.channelId);
      emit(ChatChannelMessagesLoaded(messages));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final message = await _chatRepository.sendChannelMessage(
        event.channelId,
        event.senderUsername,
        event.content,
      );
      emit(ChatMessageSentSuccess(Message.fromJson(message)));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onMessageDeleted(
    ChatMessageDeleted event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      await _chatRepository.deleteMessage(event.channelId, event.messageId);
      emit(ChatMessageDeletedSuccess());
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelCreated(
    ChatChannelCreated event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final channel = await _chatRepository.createChannel(event.channelData);
      emit(ChatChannelCreatedSuccess(Channel.fromJson(channel)));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelJoined(
    ChatChannelJoined event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      await _chatRepository.joinChannel(event.channelId);
      emit(ChatChannelJoinedSuccess());
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelJoinRequested(
    ChatChannelJoinRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      await _chatRepository.requestJoinChannel(event.channelId);
      emit(ChatChannelJoinRequestedSuccess());
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelDetailsRequested(
    ChatChannelDetailsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final details = await _chatRepository.getChannelDetails(event.channelId);
      emit(ChatChannelDetailsLoaded(details));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelDashboardRequested(
    ChatChannelDashboardRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final dashboard =
          await _chatRepository.getChannelDashboardData(event.channelId);
      emit(ChatChannelDashboardLoaded(dashboard));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelRolesChecked(
    ChatChannelRolesChecked event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final roles = await _chatRepository.checkChannelRoles(event.channelId);
      emit(ChatChannelRolesLoaded(roles));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onAdminActionPerformed(
    ChatAdminActionPerformed event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      await _chatRepository.performAdminAction(
        event.channelId,
        event.action,
        event.userId,
      );
      emit(ChatAdminActionSuccess());
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelInvitationsRequested(
    ChatChannelInvitationsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final invitations =
          await _chatRepository.getChannelInvitations(event.channelId);
      emit(ChatChannelInvitationsLoaded(invitations));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onChannelBlockedUsersRequested(
    ChatChannelBlockedUsersRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final blockedUsers =
          await _chatRepository.getChannelBlockedUsers(event.channelId);
      emit(ChatChannelBlockedUsersLoaded(blockedUsers));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onUserInvitationsRequested(
    ChatUserInvitationsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final invitations =
          await _chatRepository.getUserInvitations(event.userId);
      emit(ChatUserInvitationsLoaded(invitations));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onUserMessagesRequested(
    ChatUserMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = await _chatRepository.getUserMessages(
        event.currentUsername,
        event.otherUsername,
      );
      emit(ChatUserMessagesLoaded(
          messages.entries.map((e) => Message.fromJson(e.value)).toList()));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }

  Future<void> _onUserMessageSent(
    ChatUserMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final message = await _chatRepository.sendUserMessage(
        event.senderUsername,
        event.recipientUsername,
        event.content,
      );
      emit(ChatUserMessageSentSuccess(Message.fromJson(message)));
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
}
