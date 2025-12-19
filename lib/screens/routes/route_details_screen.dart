import 'package:flutter/material.dart';
import 'package:ecofleet_mobile/models/route_model.dart';
import 'package:ecofleet_mobile/utils/constants.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_state.dart';

class RouteDetailsScreen extends StatelessWidget {
  final BusRoute route;
  
  const RouteDetailsScreen({super.key, required this.route});

  Color get _routeColor {
    // Basic hex parsing if needed, but we essentially trust the mock data format or helper
    // Mock data had '0xFF...' format as string in my dart file, so we can parse it
    try {
      return Color(int.parse(route.colorHex));
    } catch (_) {
      return AppColors.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: _routeColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                       Container(color: _routeColor),
                       Container(
                         decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.topCenter,
                             end: Alignment.bottomCenter,
                             colors: [Colors.black12, Colors.black45],
                           ),
                         ),
                       ),
                       Positioned(
                         bottom: 60,
                         left: 20,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(20),
                               ),
                               child: Text(
                                 "Route ${route.routeId}",
                                 style: TextStyle(
                                   color: _routeColor,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                             const SizedBox(height: 8),
                             Text(
                               route.routeName,
                               style: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 24,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             Text(
                               "Operated by ${route.operatorName}",
                               style: const TextStyle(
                                 color: Colors.white70,
                                 fontSize: 14,
                               ),
                             ),
                           ],
                         ),
                       )
                    ],
                  ),
                ),
                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: "Stops"),
                    Tab(text: "Live Buses"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildStopsTimeline(context),
              _buildLiveBusesList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStopsTimeline(BuildContext context) {
    // In a real app we'd filter stops for this route.
    // Our mock stops have `routes` list.
    return BlocBuilder<BusDataBloc, BusDataState>(
      builder: (context, state) {
        if (state is BusDataLoaded) {
          final routeStops = state.stops.where((s) => s.routeIds.contains(route.routeId)).toList();
          
          if (routeStops.isEmpty) {
             return const Center(child: Text("No stops found for this route"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: routeStops.length,
            itemBuilder: (context, index) {
              final stop = routeStops[index];
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: _routeColor, width: 4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (index < routeStops.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: Colors.grey.shade300,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stop.stopName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Next bus in 5 min", // Mock
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildLiveBusesList(BuildContext context) {
    return BlocBuilder<BusDataBloc, BusDataState>(
      builder: (context, state) {
        if (state is BusDataLoaded) {
          final routeBuses = state.activeBuses.where((b) => b.routeId == route.routeId).toList();
          
          if (routeBuses.isEmpty) {
             return const Center(child: Text("No active buses on this route right now"));
          }
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: routeBuses.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final bus = routeBuses[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.directions_bus, color: _routeColor, size: 32),
                  title: Text("Bus ${bus.busId}"),
                  subtitle: Text("Capacity: ${bus.occupancy}/${bus.capacity}"),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _occupancyColor(bus.occupancy, bus.capacity).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${bus.etaMinutes} min away",
                      style: TextStyle(
                        color: _occupancyColor(bus.occupancy, bus.capacity),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
  
  Color _occupancyColor(int occupancy, int capacity) {
    final ratio = occupancy / capacity;
    if (ratio > 0.9) return Colors.red;
    if (ratio > 0.6) return Colors.orange;
    return Colors.green;
  }
}
