import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecofleet_mobile/utils/theme.dart';
import 'package:ecofleet_mobile/blocs/theme/theme_cubit.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_bloc.dart';
import 'package:ecofleet_mobile/services/mock_api_service.dart';
import 'package:ecofleet_mobile/screens/splash/splash_screen.dart';
import 'package:ecofleet_mobile/blocs/bus_data/bus_data_event.dart'; // Import for initial event

void main() {
  runApp(const EcoFleetApp());
}

class EcoFleetApp extends StatelessWidget {
  const EcoFleetApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize things like singletons or get_it here if needed
    // create the API Service
    final apiService = MockApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<BusDataBloc>(
          create: (_) => BusDataBloc(apiService: apiService)..add(LoadBusData()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'EcoFleet Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
