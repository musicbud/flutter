import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../models/message.dart';
import 'chat_screen_event.dart';
import 'chat_screen_state.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
  final ChatRepository _chatRepository;
  final String _currentUsername;

  ChatScreenBloc({
    required ChatRepository chatRepository,
    required String currentUsername,
  })  : _chatRepository = chatRepository,
        _currentUsername = currentUsername,
        super(ChatScreenInitial()) {
    on<ChatScreenMessagesRequested>(_onChatScreenMessagesRequested);
    on<ChatScreenMessageSent>(_onChatScreenMessageSent);
    on<ChatScreenMessageReceived>(_onChatScreenMessageReceived);
    on<ChatScreenTypingStarted>(_onChatScreenTypingStarted);
    on<ChatScreenTypingStopped>(_onChatScreenTypingStopped);
  }

  Future<void> _onChatScreenMessagesRequested(
    ChatScreenMessagesRequested event,
    Emitter<ChatScreenState> emit,
  ) async {
    emit(ChatScreenLoading());
    try {
      final response = await _chatRepository.getUserMessages(
        _currentUsername,
        event.userId,
      );
      final messages = (response['messages'] as List)
          .map((m) => Message.fromJson(m))
          .toList();
      emit(ChatScreenLoaded(messages: messages));
    } catch (e) {
      emit(ChatScreenFailure(e.toString()));
    }
  }

  Future<void> _onChatScreenMessageSent(
    ChatScreenMessageSent event,
    Emitter<ChatScreenState> emit,
  ) async {
    try {
      final response = await _chatRepository.sendUserMessage(
        _currentUsername,
        event.userId,
        event.message,
      );
      final message = Message.fromJson(response);
      emit(ChatScreenMessageSendSuccess(message));

      if (state is ChatScreenLoaded) {
        final currentState = state as ChatScreenLoaded;
        emit(currentState.copyWith(
          messages: [...currentState.messages, message],
        ));
      }
    } catch (e) {
      emit(ChatScreenFailure(e.toString()));
    }
  }

  void _onChatScreenMessageReceived(
    ChatScreenMessageReceived event,
    Emitter<ChatScreenState> emit,
  ) {
    try {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        channelId: 0, // Direct message, no channel
        content: event.message,
        senderUsername: event.userId,
        senderDisplayName: event.userId,
        createdAt: DateTime.now(),
      );
      emit(ChatScreenMessageReceiveSuccess(message));

      if (state is ChatScreenLoaded) {
        final currentState = state as ChatScreenLoaded;
        emit(currentState.copyWith(
          messages: [...currentState.messages, message],
          isTyping: false,
          typingUserId: null,
        ));
      }
    } catch (e) {
      emit(ChatScreenFailure(e.toString()));
    }
  }

  void _onChatScreenTypingStarted(
    ChatScreenTypingStarted event,
    Emitter<ChatScreenState> emit,
  ) {
    emit(ChatScreenTypingStatus(userId: event.userId, isTyping: true));

    if (state is ChatScreenLoaded) {
      final currentState = state as ChatScreenLoaded;
      emit(currentState.copyWith(
        isTyping: true,
        typingUserId: event.userId,
      ));
    }
  }

  void _onChatScreenTypingStopped(
    ChatScreenTypingStopped event,
    Emitter<ChatScreenState> emit,
  ) {
    emit(ChatScreenTypingStatus(userId: event.userId, isTyping: false));

    if (state is ChatScreenLoaded) {
      final currentState = state as ChatScreenLoaded;
      emit(currentState.copyWith(
        isTyping: false,
        typingUserId: null,
      ));
    }
  }
}
