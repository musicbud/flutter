import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'token_event.dart';
import 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final AuthRepository _authRepository;

  TokenBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(TokenInitial()) {
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
  }

  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<TokenState> emit,
  ) async {
    emit(TokenRefreshing());
    try {
      final token = await _authRepository.refreshToken();
      emit(TokenRefreshSuccess({'token': token}));
    } catch (e) {
      emit(TokenRefreshFailure(e.toString()));
    }
  }
}
