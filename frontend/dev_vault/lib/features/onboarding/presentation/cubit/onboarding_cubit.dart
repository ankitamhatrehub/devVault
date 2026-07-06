import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void setPage(int pageIndex) => emit(pageIndex);

  void nextPage(int totalPages) {
    if (state < totalPages - 1) {
      emit(state + 1);
    }
  }

  void previousPage() {
    if (state > 0) {
      emit(state - 1);
    }
  }

  void skipToEnd(int totalPages) => emit(totalPages - 1);
}
