import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';
import 'package:invulnerable_iot/pages/nav/main_page.dart';

class InventoryPage extends StatefulWidget {
  final IntCallback gotoTab;

  const InventoryPage({super.key, required this.gotoTab});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          final primaryState = (state as PrimaryState);
          var devices = primaryState.devices
              .where((device) => device.isAdopted == true)
              .toList();
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    AppLargeText(text: "Inventory"),
                    AppText(
                      text: "These are devices you've identified on your "
                          "network. If they are red, it has a new service "
                          "you should check on.",
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: state.devices.isEmpty
                      ? LayoutBuilder(builder: (builder, constraints) {
                          return InkWell(
                            onTap: () {
                              widget.gotoTab(1);
                            },
                            child: Center(
                              child: SizedBox(
                                width: constraints.maxWidth * 0.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wifi_find,
                                      size: min(constraints.maxHeight,
                                              constraints.maxWidth) *
                                          0.5,
                                    ),
                                    AppText(
                                      text: "No devices found",
                                      size: 20,
                                      weight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 20),
                                    AppText(
                                      text: "Look in the Strange devices tab"
                                          " to find new devices.",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                      : ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (_, i) {
                            ThemeData theme = Theme.of(context);
                            final device = devices[i];
                            return ListTile(
                              leading: device.services
                                      .any((service) => !service.isKnown)
                                  ? Icon(Icons.sentiment_satisfied,
                                      color: theme.colorScheme.error)
                                  : Icon(Icons.sentiment_very_satisfied),
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
                                    .devicePage(device: devices[i]);
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
