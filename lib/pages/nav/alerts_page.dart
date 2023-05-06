import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          final primaryState = (state as PrimaryState);
          var devices = primaryState.devices
              .where((device) =>
                  device.isAdopted == false ||
                  device.services.any((service) => service.isKnown == false))
              .toList();
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    AppLargeText(text: "Advice and Alerts"),
                    AppText(
                      text: "These devices were found on your network. "
                          "Please review the list. It's important to identify "
                          "all devices on your network to keep it secure. "
                          "When you identify a device, it will be moved to "
                          "your inventory.",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: state.devices.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (_, i) {
                            return ListTile(
                              leading: Icon(Icons.star),
                              title: Text(
                                devices[i].name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                // We can't emit from here, but we can call the Cubit's method
                                context
                                    .read<AppCubits>()
                                    .devicePage(devices[i]);
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
