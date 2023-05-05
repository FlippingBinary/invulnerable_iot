import 'package:equatable/equatable.dart';
import 'package:invulnerable_iot/model/data_model.dart';

abstract class CubitStates extends Equatable {
}

class WelcomeState extends CubitStates {
  @override
  List<Object> get props => [];
}

class PrimaryState extends CubitStates {
  PrimaryState(this.devices);
  final List<DataModel> devices;
  @override
  List<Object> get props => [devices];
}

class DetailState extends CubitStates {
  DetailState(this.device);
  final DataModel device;
  @override
  List<Object> get props => [device];
}

