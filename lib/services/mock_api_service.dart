import 'dart:async';
import 'dart:math';
import 'package:ecofleet_mobile/models/bus_model.dart';
import 'package:ecofleet_mobile/models/route_model.dart';
import 'package:ecofleet_mobile/models/stop_model.dart';
import 'package:ecofleet_mobile/utils/mock_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For LatLng if needed, but keeping it generic is better? No, LatLng is nice.

class MockApiService {
  final Random _random = Random();

  Future<List<BusRoute>> getRoutes() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency
    return mockRoutesData.map((e) => BusRoute.fromJson(e)).toList();
  }

  Future<List<BusStop>> getStops() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return mockStopsData.map((e) => BusStop.fromJson(e)).toList();
  }

  Future<List<Bus>> getBuses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockBusesData.map((e) => Bus.fromJson(e)).toList();
  }
  
  // Real-time updates simulation
  Stream<List<Bus>> getBusUpdatesStream() {
    return Stream.periodic(const Duration(seconds: 5), (count) {
      // Simulate bus movement
      return _simulateBusMovement();
    }).asBroadcastStream();
  }

  List<Bus> _simulateBusMovement() {
    // We will start with the base mock data and perturb it
    // In a real app we'd maintain state of "current" positions, but for this mock
    // we can just return slightly randomized versions of the original to keep it simple
    // or better yet, maintain a local list that updates.
    
    // For this implementation, let's just randomize the provided list slightly each time
    // so it looks like they are moving.
    
    return mockBusesData.map((e) {
      double lat = e['latitude'];
      double lng = e['longitude'];
      
      // Move by ~50-100 meters random direction
      // 0.001 deg is approx 111m
      double deltaLat = (_random.nextDouble() - 0.5) * 0.002;
      double deltaLng = (_random.nextDouble() - 0.5) * 0.002;
      
      var busClone = Map<String, dynamic>.from(e);
      busClone['latitude'] = lat + deltaLat;
      busClone['longitude'] = lng + deltaLng;
      
      // Also randomize speed/occupancy slightly
      busClone['speed'] = 20 + _random.nextDouble() * 40; // 20-60 km/h
      
      return Bus.fromJson(busClone);
    }).toList();
  }
}
