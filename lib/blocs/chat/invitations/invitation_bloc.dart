import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import 'invitation_event.dart';
import 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final ChatRepository _chatRepository;

  InvitationBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(InvitationInitial()) {
    on<InvitationAccepted>(_onInvitationAccepted);
    on<InvitationRejected>(_onInvitationRejected);
    on<ChannelInvitationsRequested>(_onChannelInvitationsRequested);
    on<UserInvitationsRequested>(_onUserInvitationsRequested);
  }

  Future<void> _onInvitationAccepted(
    InvitationAccepted event,
    Emitter<InvitationState> emit,
  ) async {
    try {
      await _chatRepository.addChannelMember(
          event.channelId.toString(), event.userId);
      emit(InvitationAcceptedSuccess());
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onInvitationRejected(
    InvitationRejected event,
    Emitter<InvitationState> emit,
  ) async {
    try {
      await _chatRepository.kickUser(event.channelId.toString(), event.userId);
      emit(InvitationRejectedSuccess());
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onChannelInvitationsRequested(
    ChannelInvitationsRequested event,
    Emitter<InvitationState> emit,
  ) async {
    emit(InvitationLoading());
    try {
      final invitations = await _chatRepository
          .getChannelInvitations(event.channelId.toString());
      emit(ChannelInvitationsLoaded(invitations));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onUserInvitationsRequested(
    UserInvitationsRequested event,
    Emitter<InvitationState> emit,
  ) async {
    emit(InvitationLoading());
    try {
      final invitations =
          await _chatRepository.getUserInvitations(event.userId.toString());
      emit(UserInvitationsLoaded(invitations));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }
}
