import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'chat_home_event.dart';
import 'chat_home_state.dart';

class ChatHomeBloc extends Bloc<ChatHomeEvent, ChatHomeState> {
  final ProfileRepository _profileRepository;

  ChatHomeBloc({
    required ProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(ChatHomeInitial()) {
    on<ChatHomeInitialized>(_onChatHomeInitialized);
    on<ChatHomeTabChanged>(_onChatHomeTabChanged);
    on<ChatHomeRefreshRequested>(_onChatHomeRefreshRequested);
  }

  Future<void> _onChatHomeInitialized(
    ChatHomeInitialized event,
    Emitter<ChatHomeState> emit,
  ) async {
    await _loadChatHomeState(emit, 0);
  }

  Future<void> _onChatHomeTabChanged(
    ChatHomeTabChanged event,
    Emitter<ChatHomeState> emit,
  ) async {
    await _loadChatHomeState(emit, event.tabIndex);
  }

  Future<void> _onChatHomeRefreshRequested(
    ChatHomeRefreshRequested event,
    Emitter<ChatHomeState> emit,
  ) async {
    if (state is ChatHomeLoaded) {
      await _loadChatHomeState(emit, (state as ChatHomeLoaded).currentTabIndex);
    } else {
      await _loadChatHomeState(emit, 0);
    }
  }

  Future<void> _loadChatHomeState(
    Emitter<ChatHomeState> emit,
    int tabIndex,
  ) async {
    try {
      emit(ChatHomeLoading());

      final userProfile = await _profileRepository.getMyProfile();
      emit(ChatHomeLoaded(
        currentTabIndex: tabIndex,
        isAuthenticated: true,
        username: userProfile.username,
      ));
    } catch (error) {
      emit(ChatHomeFailure(error.toString()));
    }
  }
}
