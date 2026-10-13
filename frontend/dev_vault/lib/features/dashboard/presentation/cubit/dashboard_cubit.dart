import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/dashboard_model.dart';
import '../../../../data/services/dashboard_service.dart';

class DashboardState {
  const DashboardState({this.dashboard, this.isLoading = true, this.error});

  final DashboardModel? dashboard;
  final bool isLoading;
  final String? error;

  DashboardState copyWith({
    DashboardModel? dashboard,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      dashboard: dashboard ?? this.dashboard,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final dashboard = await DashboardService.getDashboard();
      emit(state.copyWith(dashboard: dashboard, isLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
