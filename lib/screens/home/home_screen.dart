import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_bloc.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_state.dart';
import 'package:ecofleet_mobile/utils/constants.dart';
import 'package:ecofleet_mobile/models/bus_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  
  // Kigali Center
  static const CameraPosition _kigaliCenter = CameraPosition(
    target: LatLng(-1.9536, 30.0605),
    zoom: 13.5,
  );

  String? _mapStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load map style based on theme if needed
    // Default Google Map style is usually fine but custom style is "Pro"
    // We can load JSON styles here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildSearchBar(),
          _buildLocationButton(),
          // _buildNearbyStopsHandle(), // Implement later
        ],
      ),
    );
  }

  Widget _buildMap() {
    return BlocConsumer<BusDataBloc, BusDataState>(
      listener: (context, state) {
        // Handle side effects like moving camera to selected route
      },
      builder: (context, state) {
        Set<Marker> markers = {};
        
        if (state is BusDataLoaded) {
          // Bus Markers
          for (var bus in state.activeBuses) {
             // We can differentiate colors based on route or generic
            markers.add(Marker(
              markerId: MarkerId(bus.busId),
              position: LatLng(bus.latitude, bus.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                 // Simple color logic for now. 101=Blue, 102=Yellow, etc.
                 bus.routeId.startsWith('101') ? BitmapDescriptor.hueAzure : 
                 bus.routeId.startsWith('102') ? BitmapDescriptor.hueYellow : BitmapDescriptor.hueGreen
              ),
              infoWindow: InfoWindow(
                title: "Route ${bus.routeId}",
                snippet: "ETA: ${bus.etaMinutes} min to ${bus.nextStopId}",
              ),
            ));
          }
          
          // Stop Markers (maybe smaller or different icon)
          for (var stop in state.stops) {
            markers.add(Marker(
              markerId: MarkerId(stop.stopId),
              position: LatLng(stop.latitude, stop.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), 
              // Ideally use a bus stop icon
              infoWindow: InfoWindow(title: stop.stopName),
            ));
          }
        }

        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kigaliCenter,
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false, // We'll build our own
          zoomControlsEnabled: false, // We'll build our own or rely on gestures for cleaner UI
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            // controller.setMapStyle(_mapStyle);
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 50, // Safe area
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          decoration: const InputDecoration(
            hintText: "Where to?",
            border: InputBorder.none,
            icon: Icon(Icons.search, color: AppColors.primaryBlue),
            suffixIcon: Icon(Icons.mic, color: AppColors.textSecondaryLight),
          ),
          onTap: () {
            // Navigate to Route Search Screen
            // Navigator.push...
          },
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return Positioned(
      bottom: 120, // Above bottom sheet
      right: 16,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(_kigaliCenter));
          // In real app, get user location
        },
        child: const Icon(Icons.my_location, color: AppColors.primaryBlue),
      ),
    );
  }
}
