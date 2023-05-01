import 'package:equatable/equatable.dart';
import 'package:invulnerable_iot/model/data_model.dart';

abstract class CubitStates extends Equatable {
}

class InitialState extends CubitStates {
  @override
  List<Object> get props => [];
}

class WelcomeState extends CubitStates {
  @override
  List<Object> get props => [];
}

class LoadingState extends CubitStates {
  @override
  List<Object> get props => [];
}

class LoadedState extends CubitStates {
  LoadedState(this.services);
  final List<DataModel> services;
  @override
  List<Object> get props => [services];
}

class DetailState extends CubitStates {
  DetailState(this.service);
  final DataModel service;
  @override
  List<Object> get props => [service];
}

