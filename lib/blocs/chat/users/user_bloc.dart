import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/models/channel_user.dart';
import 'user_event.dart';
import 'user_state.dart';

class ChatUserBloc extends Bloc<ChatUserEvent, ChatUserState> {
  final ChatRepository _chatRepository;

  ChatUserBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(ChatUserInitial()) {
    on<ChannelUsersRequested>(_onChannelUsersRequested);
    on<ChannelRolesChecked>(_onChannelRolesChecked);
  }

  Future<void> _onChannelUsersRequested(
    ChannelUsersRequested event,
    Emitter<ChatUserState> emit,
  ) async {
    emit(ChatUserLoading());
    try {
      final users =
          await _chatRepository.getChannelUsers(event.channelId.toString());
      final usersList = (users['users'] as List)
          .map((u) => ChannelUser.fromJson(Map<String, dynamic>.from(u)))
          .toList();
      emit(ChannelUsersLoaded(usersList));
    } catch (e) {
      emit(ChatUserFailure(e.toString()));
    }
  }

  Future<void> _onChannelRolesChecked(
    ChannelRolesChecked event,
    Emitter<ChatUserState> emit,
  ) async {
    emit(ChatUserLoading());
    try {
      final roles =
          await _chatRepository.checkChannelRoles(event.channelId.toString());
      emit(ChannelRolesLoaded(roles));
    } catch (e) {
      emit(ChatUserFailure(e.toString()));
    }
  }
}
