import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/bud_repository.dart';
import 'bud_common_items_event.dart';
import 'bud_common_items_state.dart';

class BudCommonItemsBloc
    extends Bloc<BudCommonItemsEvent, BudCommonItemsState> {
  final BudRepository _budRepository;

  BudCommonItemsBloc({
    required BudRepository budRepository,
  })  : _budRepository = budRepository,
        super(BudCommonItemsInitial()) {
    on<BudCommonItemsRequested>(_onBudCommonItemsRequested);
    on<BudCommonItemsRefreshRequested>(_onBudCommonItemsRefreshRequested);
  }

  Future<void> _onBudCommonItemsRequested(
    BudCommonItemsRequested event,
    Emitter<BudCommonItemsState> emit,
  ) async {
    emit(BudCommonItemsLoading());
    try {
      final commonTracks = await _budRepository.getCommonTracks(event.budId);
      final commonArtists = await _budRepository.getCommonArtists(event.budId);
      final commonGenres = await _budRepository.getCommonGenres(event.budId);
      final commonPlayedTracks =
          await _budRepository.getCommonPlayedTracks(event.budId);

      emit(BudCommonItemsLoaded(
        commonTracks: commonTracks,
        commonArtists: commonArtists,
        commonGenres: commonGenres,
        commonPlayedTracks: commonPlayedTracks,
      ));
    } catch (e) {
      emit(BudCommonItemsFailure(e.toString()));
    }
  }

  Future<void> _onBudCommonItemsRefreshRequested(
    BudCommonItemsRefreshRequested event,
    Emitter<BudCommonItemsState> emit,
  ) async {
    try {
      final commonTracks = await _budRepository.getCommonTracks(event.budId);
      final commonArtists = await _budRepository.getCommonArtists(event.budId);
      final commonGenres = await _budRepository.getCommonGenres(event.budId);
      final commonPlayedTracks =
          await _budRepository.getCommonPlayedTracks(event.budId);

      emit(BudCommonItemsLoaded(
        commonTracks: commonTracks,
        commonArtists: commonArtists,
        commonGenres: commonGenres,
        commonPlayedTracks: commonPlayedTracks,
      ));
    } catch (e) {
      emit(BudCommonItemsFailure(e.toString()));
    }
  }
}
