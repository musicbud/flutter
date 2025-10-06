import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../models/message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatInitial()) {
    on<ChatChannelListRequested>(_onChannelListRequested);
    on<ChatUserListRequested>(_onUserListRequested);
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
    on<ChatChannelMemberAdded>(_onChannelMemberAdded);
    on<ChatChannelStatisticsRequested>(_onChannelStatisticsRequested);
    on<SendMessage>(_onSendMessage);
    on<LoadMessages>(_onLoadMessages);
    on<LoadDirectMessages>(_onLoadDirectMessages);
    on<SendDirectMessage>(_onSendDirectMessage);
  }

  Future<void> _onChannelListRequested(
    ChatChannelListRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final channels = await _chatRepository.getChannels();
      emit(ChatChannelListLoaded(channels));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onUserListRequested(
    ChatUserListRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final users = await _chatRepository.getUsers();
      emit(ChatUserListLoaded(users));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelUsersRequested(
    ChatChannelUsersRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Get channel users not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelMessagesRequested(
    ChatChannelMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = await _chatRepository.getChannelMessages(
        event.channelId,
        limit: event.limit,
        before: event.before,
      );
      emit(ChatChannelMessagesLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
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
        event.content,
      );
      emit(ChatMessageSentSuccess(message));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onMessageDeleted(
    ChatMessageDeleted event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      await _chatRepository.deleteMessage(
        event.channelId.toString(),
        event.messageId.toString(),
      );
      emit(const ChatMessageDeletedSuccess());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelCreated(
    ChatChannelCreated event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final channel = await _chatRepository.createChannel(
        event.name,
        event.description,
        isPrivate: event.isPrivate,
      );
      emit(ChatChannelCreatedSuccess(channel));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelJoined(
    ChatChannelJoined event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Join channel not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelJoinRequested(
    ChatChannelJoinRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Request join channel not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelDetailsRequested(
    ChatChannelDetailsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Get channel details not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelDashboardRequested(
    ChatChannelDashboardRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Get channel dashboard not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelRolesChecked(
    ChatChannelRolesChecked event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Check channel roles not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onAdminActionPerformed(
    ChatAdminActionPerformed event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _chatRepository.performAdminAction(
        event.channelId.toString(),
        event.action,
        event.userId.toString(),
      );
      emit(const ChatAdminActionSuccess());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelInvitationsRequested(
    ChatChannelInvitationsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Get channel invitations not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelBlockedUsersRequested(
    ChatChannelBlockedUsersRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Get channel blocked users not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onUserInvitationsRequested(
    ChatUserInvitationsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Get user invitations not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
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
        limit: null,
        before: null,
      );
      emit(ChatUserMessagesLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
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
        event.content,
      );
      emit(ChatUserMessageSentSuccess(message));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelMemberAdded(
    ChatChannelMemberAdded event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _chatRepository.addChannelMember(event.channelId, event.username);
      emit(ChatChannelJoinedSuccess());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onChannelStatisticsRequested(
    ChatChannelStatisticsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // This functionality is not supported by the API
      emit(const ChatError('Get channel statistics not supported by API'));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      await _chatRepository.sendMessage(
        channelId: event.channelId,
        message: event.message,
        userId: event.userId,
      );
      emit(MessageSent());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());
      final messages = await _chatRepository.getMessages(
        channelId: event.channelId,
        limit: event.limit,
        beforeId: event.beforeId,
      );
      final typedMessages = messages
          .map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList();
      emit(MessagesLoaded(typedMessages));
    } catch (error) {
      emit(ChatError(error.toString()));
    }
  }

  Future<void> _onLoadDirectMessages(
    LoadDirectMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = await _chatRepository.getUserMessages(
        event.userId,
        limit: event.limit,
        before: event.beforeId,
      );
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendDirectMessage(
    SendDirectMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _chatRepository.sendUserMessage(
        event.userId,
        event.message,
      );
      emit(MessageSent());
      emit(MessagesLoaded(await _chatRepository.getUserMessages(event.userId)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
