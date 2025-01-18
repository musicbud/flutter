import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';
import 'invitation_event.dart';
import 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final ChatRepository _chatRepository;

  InvitationBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(InvitationInitial()) {
    on<ChannelInvitationsSent>(_onChannelInvitationsSent);
    on<ChannelInvitationsAccepted>(_onChannelInvitationsAccepted);
    on<ChannelInvitationsRejected>(_onChannelInvitationsRejected);
    on<ChannelInvitationsListRequested>(_onChannelInvitationsListRequested);
    on<UserInvitationsListRequested>(_onUserInvitationsListRequested);
  }

  Future<void> _onChannelInvitationsSent(
    ChannelInvitationsSent event,
    Emitter<InvitationState> emit,
  ) async {
    emit(InvitationLoading());
    try {
      await _chatRepository.addChannelMember(event.channelId, event.username);
      emit(InvitationSentSuccess());
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onChannelInvitationsAccepted(
    ChannelInvitationsAccepted event,
    Emitter<InvitationState> emit,
  ) async {
    emit(InvitationLoading());
    try {
      await _chatRepository.acceptUser(event.channelId, event.userId);
      emit(InvitationAcceptedSuccess());
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onChannelInvitationsRejected(
    ChannelInvitationsRejected event,
    Emitter<InvitationState> emit,
  ) async {
    emit(InvitationLoading());
    try {
      await _chatRepository.removeChannelMember(event.channelId, event.userId);
      emit(InvitationRejectedSuccess());
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onChannelInvitationsListRequested(
    ChannelInvitationsListRequested event,
    Emitter<InvitationState> emit,
  ) async {
    emit(InvitationLoading());
    try {
      final invitations =
          await _chatRepository.getChannelInvitations(event.channelId);
      emit(ChannelInvitationsLoaded(invitations));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }

  Future<void> _onUserInvitationsListRequested(
    UserInvitationsListRequested event,
    Emitter<InvitationState> emit,
  ) async {
    emit(InvitationLoading());
    try {
      final invitations =
          await _chatRepository.getUserInvitations(event.userId);
      emit(UserInvitationsLoaded(invitations));
    } catch (e) {
      emit(InvitationFailure(e.toString()));
    }
  }
}
