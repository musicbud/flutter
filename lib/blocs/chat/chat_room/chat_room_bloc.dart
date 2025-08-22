import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/models/message.dart';
import '../../../domain/models/user_profile.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRepository _chatRepository;

  ChatRoomBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatRoomInitial()) {
    on<ChatRoomMessagesRequested>(_onChatRoomMessagesRequested);
    on<ChatRoomMessageSent>(_onChatRoomMessageSent);
    on<ChatRoomMessageDeleted>(_onChatRoomMessageDeleted);
    on<ChatRoomMessageEdited>(_onChatRoomMessageEdited);
    on<ChatRoomTypingStarted>(_onChatRoomTypingStarted);
    on<ChatRoomTypingStopped>(_onChatRoomTypingStopped);
    on<ChatRoomReactionAdded>(_onChatRoomReactionAdded);
    on<ChatRoomReactionRemoved>(_onChatRoomReactionRemoved);
    on<ChatRoomMembersRequested>(_onChatRoomMembersRequested);
    on<ChatRoomDetailsRequested>(_onChatRoomDetailsRequested);
    on<ChatRoomJoinRequested>(_onChatRoomJoinRequested);
    on<ChatRoomLeaveRequested>(_onChatRoomLeaveRequested);
    on<ChatRoomMuteRequested>(_onChatRoomMuteRequested);
    on<ChatRoomUnmuteRequested>(_onChatRoomUnmuteRequested);
  }

  Future<void> _onChatRoomMessagesRequested(
    ChatRoomMessagesRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      emit(ChatRoomLoading());
      final messages = await _chatRepository.getChannelMessages(
        event.channelId,
        limit: event.limit,
        before: event.before,
      );
      emit(ChatRoomLoaded(messages: messages));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomMessageSent(
    ChatRoomMessageSent event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      final message = await _chatRepository.sendChannelMessage(
        event.channelId,
        event.content,
      );
      emit(ChatRoomMessageSentSuccess(message: message));

      // Reload messages after sending
      final messages = await _chatRepository.getChannelMessages(
        event.channelId,
        limit: 50,
      );
      emit(ChatRoomLoaded(messages: messages));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomMessageDeleted(
    ChatRoomMessageDeleted event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      await _chatRepository.deleteMessage(
        event.channelId,
        event.messageId,
      );
      emit(ChatRoomMessageDeletedSuccess());

      // Reload messages after deletion
      final messages = await _chatRepository.getChannelMessages(
        event.channelId,
        limit: 50,
      );
      emit(ChatRoomLoaded(messages: messages));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomMessageEdited(
    ChatRoomMessageEdited event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      // This would need to be implemented in the repository
      emit(ChatRoomMessageEditedSuccess());

      // Reload messages after editing
      final messages = await _chatRepository.getChannelMessages(
        event.channelId,
        limit: 50,
      );
      emit(ChatRoomLoaded(messages: messages));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomTypingStarted(
    ChatRoomTypingStarted event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      // Emit typing indicator
      emit(ChatRoomTypingStartedState(username: event.username));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomTypingStopped(
    ChatRoomTypingStopped event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      // Emit typing stopped
      emit(ChatRoomTypingStoppedState(username: event.username));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomReactionAdded(
    ChatRoomReactionAdded event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      // This would need to be implemented in the repository
      emit(ChatRoomReactionAddedSuccess());
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomReactionRemoved(
    ChatRoomReactionRemoved event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      // This would need to be implemented in the repository
      emit(ChatRoomReactionRemovedSuccess());
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomMembersRequested(
    ChatRoomMembersRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      final members = await _chatRepository.getChannelMembers(event.channelId);
      emit(ChatRoomMembersLoaded(members: members));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomDetailsRequested(
    ChatRoomDetailsRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      final details = await _chatRepository.getChannelDetails(event.channelId);
      emit(ChatRoomDetailsLoaded(details: details));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomJoinRequested(
    ChatRoomJoinRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      await _chatRepository.joinChannel(event.channelId);
      emit(ChatRoomJoinSuccess());
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomLeaveRequested(
    ChatRoomLeaveRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      await _chatRepository.leaveChannel(event.channelId);
      emit(ChatRoomLeaveSuccess());
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomMuteRequested(
    ChatRoomMuteRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      // This would need to be implemented in the repository
      emit(ChatRoomMuteSuccess());
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomUnmuteRequested(
    ChatRoomUnmuteRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      // This would need to be implemented in the repository
      emit(ChatRoomUnmuteSuccess());
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }
}