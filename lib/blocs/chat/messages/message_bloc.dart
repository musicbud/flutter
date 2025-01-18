import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../models/message.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository _chatRepository;

  MessageBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(MessageInitial()) {
    on<ChannelMessagesRequested>(_onChannelMessagesRequested);
    on<MessageSent>(_onMessageSent);
    on<MessageDeleted>(_onMessageDeleted);
    on<DirectMessagesRequested>(_onDirectMessagesRequested);
    on<DirectMessageSent>(_onDirectMessageSent);
  }

  Future<void> _onChannelMessagesRequested(
    ChannelMessagesRequested event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final messages =
          await _chatRepository.getChannelMessages(event.channelId);
      emit(ChannelMessagesLoaded(messages));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final message = await _chatRepository.sendChannelMessage(
        event.channelId,
        event.senderUsername,
        event.content,
      );
      emit(MessageSentSuccess(
          Message.fromJson(Map<String, dynamic>.from(message))));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onMessageDeleted(
    MessageDeleted event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      await _chatRepository.deleteMessage(event.channelId, event.messageId);
      emit(MessageDeletedSuccess());
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onDirectMessagesRequested(
    DirectMessagesRequested event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final messages = await _chatRepository.getUserMessages(
        event.currentUsername,
        event.otherUsername,
      );
      final messagesList = (messages['messages'] as List)
          .map((m) => Message.fromJson(Map<String, dynamic>.from(m)))
          .toList();
      emit(DirectMessagesLoaded(messagesList));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onDirectMessageSent(
    DirectMessageSent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final message = await _chatRepository.sendUserMessage(
        event.senderUsername,
        event.recipientUsername,
        event.content,
      );
      emit(DirectMessageSentSuccess(
          Message.fromJson(Map<String, dynamic>.from(message))));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }
}
