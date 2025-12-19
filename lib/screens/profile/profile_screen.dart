import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecofleet_mobile/utils/constants.dart';
import 'package:ecofleet_mobile/blocs/theme/theme_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryBlue),
            accountName: Text("EcoFleet Passenger"),
            accountEmail: Text("passenger@ecofleet.rw"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primaryBlue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: const Text("English"),
            onTap: () {},
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, state) {
              final isDark = state == ThemeMode.dark;
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
                value: isDark,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme(value);
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () {},
          ),
           ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About EcoFleet"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
