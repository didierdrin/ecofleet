import 'package:equatable/equatable.dart';

abstract class BusDataEvent extends Equatable {
  const BusDataEvent();

  @override
  List<Object> get props => [];
}

class LoadBusData extends BusDataEvent {}

class UpdateBusLocations extends BusDataEvent {} // Triggered by timer or stream

class RefreshBusData extends BusDataEvent {}

class SelectRoute extends BusDataEvent {
  final String routeId;
  const SelectRoute(this.routeId);
  
  @override
  List<Object> get props => [routeId];
}

class ClearRouteSelection extends BusDataEvent {}
