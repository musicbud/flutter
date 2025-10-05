import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final ChatRepository _chatRepository;

  AdminBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(AdminInitial()) {
    on<AdminStatusChecked>(_onAdminStatusChecked);
    on<ModeratorAdded>(_onModeratorAdded);
    on<ModeratorRemoved>(_onModeratorRemoved);
    on<AdminAdded>(_onAdminAdded);
    on<AdminRemoved>(_onAdminRemoved);
    on<UserKicked>(_onUserKicked);
    on<UserBlocked>(_onUserBlocked);
    on<UserUnblocked>(_onUserUnblocked);
  }

  Future<void> _onAdminStatusChecked(
    AdminStatusChecked event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final isAdmin =
          await _chatRepository.isChannelAdmin(event.channelId.toString());
      emit(AdminStatusLoaded(isAdmin));
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> _onModeratorAdded(
    ModeratorAdded event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _chatRepository.addModerator(
        event.channelId.toString(),
        event.userId.toString(),
      );
      emit(ModeratorAddedSuccess());
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> _onModeratorRemoved(
    ModeratorRemoved event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _chatRepository.removeModerator(
        event.channelId.toString(),
        event.userId.toString(),
      );
      emit(ModeratorRemovedSuccess());
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> _onAdminAdded(
    AdminAdded event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _chatRepository.makeAdmin(
        event.channelId.toString(),
        event.userId.toString(),
      );
      emit(AdminAddedSuccess());
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> _onAdminRemoved(
    AdminRemoved event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _chatRepository.removeAdmin(
        event.channelId.toString(),
        event.userId.toString(),
      );
      emit(AdminRemovedSuccess());
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> _onUserKicked(
    UserKicked event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _chatRepository.kickUser(
        event.channelId.toString(),
        event.userId.toString(),
      );
      emit(UserKickedSuccess());
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> _onUserBlocked(
    UserBlocked event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _chatRepository.blockUser(
        event.channelId.toString(),
        event.userId.toString(),
      );
      emit(UserBlockedSuccess());
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> _onUserUnblocked(
    UserUnblocked event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _chatRepository.unblockUser(
        event.channelId.toString(),
        event.userId.toString(),
      );
      emit(UserUnblockedSuccess());
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }
}
