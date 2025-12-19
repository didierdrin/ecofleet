import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_event.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_state.dart';
import 'package:ecofleet_mobile/services/mock_api_service.dart';
import 'package:ecofleet_mobile/models/bus_model.dart';
import 'package:ecofleet_mobile/models/route_model.dart';
import 'package:ecofleet_mobile/models/stop_model.dart';

// Internal event
class NewBusPositionsEvent extends BusDataEvent {
  final List<Bus> buses;
  const NewBusPositionsEvent(this.buses);
  
  @override
  List<Object> get props => [buses];
}

class BusDataBloc extends Bloc<BusDataEvent, BusDataState> {
  final MockApiService _apiService;
  StreamSubscription<List<Bus>>? _busUpdatesSubscription;

  BusDataBloc({required MockApiService apiService}) 
      : _apiService = apiService, 
        super(BusDataInitial()) {
    on<LoadBusData>(_onLoadBusData);
    on<NewBusPositionsEvent>(_onNewBusPositions);
    on<SelectRoute>(_onSelectRoute);
    on<ClearRouteSelection>(_onClearRouteSelection);
    on<RefreshBusData>(_onLoadBusData);
  }

  Future<void> _onLoadBusData(BusDataEvent event, Emitter<BusDataState> emit) async {
    // Only emit loading if it's the first load or explicit refresh
    if (state is! BusDataLoaded) { // Or handle refresh loading differently
       emit(BusDataLoading());
    }
    
    try {
      final routes = await _apiService.getRoutes();
      final stops = await _apiService.getStops();
      final buses = await _apiService.getBuses();
      
      emit(BusDataLoaded(
        routes: routes,
        stops: stops,
        activeBuses: buses,
      ));
      
      _busUpdatesSubscription?.cancel();
      _busUpdatesSubscription = _apiService.getBusUpdatesStream().listen((updatedBuses) {
        add(NewBusPositionsEvent(updatedBuses));
      });
      
    } catch (e) {
      emit(BusDataError("Failed to load data: $e"));
    }
  }

  void _onNewBusPositions(NewBusPositionsEvent event, Emitter<BusDataState> emit) {
    if (state is BusDataLoaded) {
      emit((state as BusDataLoaded).copyWith(activeBuses: event.buses));
    }
  }
  
  void _onSelectRoute(SelectRoute event, Emitter<BusDataState> emit) {
    if (state is BusDataLoaded) {
      emit((state as BusDataLoaded).copyWith(selectedRouteId: event.routeId));
    }
  }
  
  void _onClearRouteSelection(ClearRouteSelection event, Emitter<BusDataState> emit) {
     if (state is BusDataLoaded) {
       final curr = state as BusDataLoaded;
       // Manually construct to set selectedRouteId to null
       emit(BusDataLoaded(
         routes: curr.routes,
         stops: curr.stops,
         activeBuses: curr.activeBuses,
         selectedRouteId: null,
         isOffline: curr.isOffline
       ));
    }
  }

  @override
  Future<void> close() {
    _busUpdatesSubscription?.cancel();
    return super.close();
  }
}
