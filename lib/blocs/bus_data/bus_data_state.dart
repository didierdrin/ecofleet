import 'package:equatable/equatable.dart';
import 'package:ecofleet_mobile/models/bus_model.dart';
import 'package:ecofleet_mobile/models/route_model.dart';
import 'package:ecofleet_mobile/models/stop_model.dart';

abstract class BusDataState extends Equatable {
  const BusDataState();
  
  @override
  List<Object?> get props => [];
}

class BusDataInitial extends BusDataState {}

class BusDataLoading extends BusDataState {}

class BusDataLoaded extends BusDataState {
  final List<BusRoute> routes;
  final List<BusStop> stops;
  final List<Bus> activeBuses;
  final String? selectedRouteId;
  final bool isOffline; // To handle offline mode mention

  const BusDataLoaded({
    required this.routes,
    required this.stops,
    required this.activeBuses,
    this.selectedRouteId,
    this.isOffline = false,
  });

  BusDataLoaded copyWith({
    List<BusRoute>? routes,
    List<BusStop>? stops,
    List<Bus>? activeBuses,
    String? selectedRouteId,
    bool? isOffline,
  }) {
    return BusDataLoaded(
      routes: routes ?? this.routes,
      stops: stops ?? this.stops,
      activeBuses: activeBuses ?? this.activeBuses,
      selectedRouteId: selectedRouteId ?? this.selectedRouteId,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [routes, stops, activeBuses, selectedRouteId, isOffline];
}

class BusDataError extends BusDataState {
  final String message;
  const BusDataError(this.message);
  
  @override
  List<Object?> get props => [message];
}
