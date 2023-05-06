import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/pages/nav/device_page.dart';
import 'package:invulnerable_iot/pages/nav/main_page.dart';
import 'package:invulnerable_iot/pages/nav/service_page.dart';
import 'package:invulnerable_iot/pages/welcome_page.dart';

class AppCubitLogics extends StatefulWidget {
  const AppCubitLogics({super.key});

  @override
  State<AppCubitLogics> createState() => _AppCubitLogicsState();
}

class _AppCubitLogicsState extends State<AppCubitLogics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          if (state is WelcomeState) {
            return WelcomePage();
          } else if (state is PrimaryState) {
            return MainPage();
          } else if (state is DeviceState) {
            return DevicePage();
          } else if (state is ServiceState) {
            return ServicePage();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
