import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
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
    on<UserMessagesRequested>(_onUserMessagesRequested);
    on<UserMessageSent>(_onUserMessageSent);
  }

  Future<void> _onChannelMessagesRequested(
    ChannelMessagesRequested event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final messages = await _chatRepository.getChannelMessages(
        event.channelId.toString(),
        limit: event.limit,
        before: event.before,
      );
      emit(MessagesLoaded(messages));
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
        event.channelId.toString(),
        event.content,
      );
      emit(MessageSentSuccess(message));
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
      await _chatRepository.deleteMessage(
        event.channelId.toString(),
        event.messageId.toString(),
      );
      emit(MessageDeletedSuccess());
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onUserMessagesRequested(
    UserMessagesRequested event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final messages = await _chatRepository.getUserMessages(
        event.userId,
        limit: event.limit,
        before: event.before,
      );
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  Future<void> _onUserMessageSent(
    UserMessageSent event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final message = await _chatRepository.sendUserMessage(
        event.userId,
        event.content,
      );
      emit(MessageSentSuccess(message));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }
}
