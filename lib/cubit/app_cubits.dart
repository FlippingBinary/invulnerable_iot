import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/model/data_model.dart';
import 'package:invulnerable_iot/services/data_services.dart';

class AppCubits extends Cubit<CubitStates> {
  final DataServices data;
  late final List<DataModel> services;

  AppCubits({required this.data}) : super(InitialState()) {
    emit(WelcomeState());
  }

  void getData() async {
    try {
      emit(LoadingState());
      services = await data.getServices();
      emit(LoadedState(services));
    } catch (e) {
      emit(WelcomeState());
    }
  }

  detailPage(DataModel service) {
    emit(DetailState(service));
  }

  goHome() {
    emit(LoadedState(services));
  }
}
