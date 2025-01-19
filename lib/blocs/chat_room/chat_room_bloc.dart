import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/models/message.dart';
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
  }

  Future<void> _onChatRoomMessagesRequested(
    ChatRoomMessagesRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      emit(ChatRoomLoading());
      final messages =
          await _chatRepository.getChannelMessages(event.channelId.toString());
      emit(ChatRoomLoaded(messages));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }

  Future<void> _onChatRoomMessageSent(
    ChatRoomMessageSent event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      await _chatRepository.sendChannelMessage(
        event.channelId.toString(),
        event.senderUsername,
        event.content,
      );
      emit(ChatRoomMessageSentSuccess());

      // Reload messages after sending
      final messages =
          await _chatRepository.getChannelMessages(event.channelId.toString());
      emit(ChatRoomLoaded(messages));
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
          event.channelId.toString(), event.messageId.toString());
      emit(ChatRoomMessageDeletedSuccess());

      // Reload messages after deletion
      final messages =
          await _chatRepository.getChannelMessages(event.channelId.toString());
      emit(ChatRoomLoaded(messages));
    } catch (error) {
      emit(ChatRoomFailure(error.toString()));
    }
  }
}
