import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_bloc.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_state.dart';
import 'package:ecofleet_mobile/screens/routes/route_details_screen.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Routes")),
      body: BlocBuilder<BusDataBloc, BusDataState>(
        builder: (context, state) {
          if (state is BusDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BusDataLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.routes.length,
              itemBuilder: (context, index) {
                final route = state.routes[index];
                final color = Color(int.parse(route.colorHex));
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          route.routeId,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    title: Text(route.routeName),
                    subtitle: Text("${route.activeBuses} active buses"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteDetailsScreen(route: route),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
