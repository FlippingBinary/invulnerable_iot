import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';
import 'package:invulnerable_iot/pages/nav/main_page.dart';

class StrangePage extends StatefulWidget {
  final IntCallback gotoTab;

  const StrangePage({super.key, required this.gotoTab});

  @override
  State<StrangePage> createState() => _StrangePageState();
}

class _StrangePageState extends State<StrangePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          final primaryState = (state as PrimaryState);
          var strangeDevices = primaryState.devices
              .where((device) => device.isAdopted == false)
              .toList();
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    AppLargeText(text: "Strange Devices"),
                    AppText(
                      text: "If strange devices are found on your network, "
                          "there is no reason to panic. Just review the "
                          "results and check back as they are updated. It's "
                          "important to identify all devices on your network "
                          "to keep it secure. After you identify a device, it "
                          "will be moved to your inventory.",
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
                              widget.gotoTab(2);
                            },
                            child: Center(
                              child: SizedBox(
                                width: constraints.maxWidth * 0.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.gpp_good,
                                      size: min(constraints.maxHeight,
                                              constraints.maxWidth) *
                                          0.5,
                                    ),
                                    AppText(
                                      text: "No strange devices found",
                                      size: 20,
                                      weight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 20),
                                    AppText(
                                      text: "Look in the inventory tab"
                                          " to find your known devices.",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                      : ListView.builder(
                          itemCount: strangeDevices.length,
                          itemBuilder: (_, i) {
                            final theme = Theme.of(context);
                            return ListTile(
                              leading: Icon(Icons.gpp_bad,
                                  color: theme.colorScheme.error),
                              title: AppText(
                                text: strangeDevices[i].name,
                                size: 20,
                                weight: FontWeight.bold,
                              ),
                              onTap: () {
                                // We can't emit from here, but we can call the Cubit's method
                                context
                                    .read<AppCubits>()
                                    .devicePage(device: strangeDevices[i]);
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
