import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursecycle/features/screening/screening_state.dart';

class ScreeningCubit extends Cubit<ScreeningState> {
  ScreeningCubit() : super(ScreeningState(isLoading: true));

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
