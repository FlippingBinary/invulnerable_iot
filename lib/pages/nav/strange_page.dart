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
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: state.devices.isEmpty
                      ? Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Icon(
                                Icons.gpp_good,
                          // set size to the greater of 250 or half the width of the screen
                                size: constraints.maxWidth > 500
                                    ? 500
                                    : constraints.maxWidth * 0.5,
                              );
                            },
                          ),
                        )
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
