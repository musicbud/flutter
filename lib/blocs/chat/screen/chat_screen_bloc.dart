import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/models/message.dart';
import 'chat_screen_event.dart';
import 'chat_screen_state.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
  final ChatRepository _chatRepository;

  ChatScreenBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatScreenInitial()) {
    on<ChatScreenMessagesRequested>(_onMessagesRequested);
    on<ChatScreenMessageSent>(_onMessageSent);
    on<ChatScreenMessageReceived>(_onMessageReceived);
    on<ChatScreenTypingStarted>(_onTypingStarted);
    on<ChatScreenTypingStopped>(_onTypingStopped);
  }

  Future<void> _onMessagesRequested(
    ChatScreenMessagesRequested event,
    Emitter<ChatScreenState> emit,
  ) async {
    emit(ChatScreenLoading());
    try {
      final messages = await _chatRepository.getUserMessages(
        event.userId,
        limit: event.limit,
        before: event.before,
      );
      emit(ChatScreenLoaded(messages));
    } catch (e) {
      emit(ChatScreenFailure(e.toString()));
    }
  }

  Future<void> _onMessageSent(
    ChatScreenMessageSent event,
    Emitter<ChatScreenState> emit,
  ) async {
    emit(ChatScreenLoading());
    try {
      final message = await _chatRepository.sendUserMessage(
        event.userId,
        event.content,
      );
      emit(ChatScreenMessageSentState(message));
    } catch (e) {
      emit(ChatScreenFailure(e.toString()));
    }
  }

  void _onMessageReceived(
    ChatScreenMessageReceived event,
    Emitter<ChatScreenState> emit,
  ) {
    if (state is ChatScreenLoaded) {
      final currentMessages = (state as ChatScreenLoaded).messages;
      emit(ChatScreenLoaded([...currentMessages, event.message]));
    }
  }

  void _onTypingStarted(
    ChatScreenTypingStarted event,
    Emitter<ChatScreenState> emit,
  ) {
    if (state is ChatScreenLoaded) {
      final currentState = state as ChatScreenLoaded;
      emit(ChatScreenLoaded(currentState.messages, isTyping: true));
    }
  }

  void _onTypingStopped(
    ChatScreenTypingStopped event,
    Emitter<ChatScreenState> emit,
  ) {
    if (state is ChatScreenLoaded) {
      final currentState = state as ChatScreenLoaded;
      emit(ChatScreenLoaded(currentState.messages, isTyping: false));
    }
  }
}
