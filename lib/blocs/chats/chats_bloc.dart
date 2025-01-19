import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../models/chat.dart';
import 'chats_event.dart';
import 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository _chatRepository;

  ChatsBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatsInitial()) {
    on<ChatsRequested>(_onChatsRequested);
    on<ChatMessageReceived>(_onChatMessageReceived);
    on<ChatRead>(_onChatRead);
    on<ChatArchived>(_onChatArchived);
    on<ChatDeleted>(_onChatDeleted);
  }

  Future<void> _onChatsRequested(
    ChatsRequested event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      emit(ChatsLoading());
      final chats = await _chatRepository.getChats();
      emit(ChatsLoaded(chats: chats));
    } catch (error) {
      emit(ChatsFailure(error: error.toString()));
    }
  }

  Future<void> _onChatMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      final chat = await _chatRepository.getChatByUserId(event.userId);
      emit(ChatMessageReceivedState(chat: chat));
    } catch (error) {
      emit(ChatsFailure(error: error.toString()));
    }
  }

  Future<void> _onChatRead(
    ChatRead event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await _chatRepository.markChatAsRead(event.userId);
      emit(ChatReadState(userId: event.userId));
    } catch (error) {
      emit(ChatsFailure(error: error.toString()));
    }
  }

  Future<void> _onChatArchived(
    ChatArchived event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await _chatRepository.archiveChat(event.userId);
      emit(ChatArchivedState(userId: event.userId));
    } catch (error) {
      emit(ChatsFailure(error: error.toString()));
    }
  }

  Future<void> _onChatDeleted(
    ChatDeleted event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await _chatRepository.deleteChat(event.userId);
      emit(ChatDeletedState(userId: event.userId));
    } catch (error) {
      emit(ChatsFailure(error: error.toString()));
    }
  }
}
