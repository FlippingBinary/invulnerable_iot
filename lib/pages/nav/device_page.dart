import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final nameController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: BlocBuilder<AppCubits, CubitStates>(
          builder: (context, state) {
            final device = (state as DeviceState).device;
            nameController.text = device.name;
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    AppLargeText(text: "Device Details"),
                    SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      onEditingComplete: () {
                        final updatedDevice =
                            device.copyWith(name: nameController.text);
                        context.read<AppCubits>().updateDevice(updatedDevice);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: device.isAdopted,
                          onChanged: (value) {
                            final updatedDevice =
                                device.copyWith(isAdopted: value);
                            context
                                .read<AppCubits>()
                                .updateDevice(updatedDevice);
                          },
                        ),
                        AppText(text: "I know this device"),
                      ],
                    ),
                    device.services.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: device.services.length,
                            itemBuilder: (_, i) {
                              final service = device.services[i];
                              return ListTile(
                                leading: service.isKnown
                                    ? Icon(Icons.settings)
                                    : Icon(
                                        Icons.settings_suggest,
                                        color: theme.colorScheme.error,
                                      ),
                                title: AppText(
                                  text: service.name,
                                ),
                                onTap: () {
                                  // We can't emit from here, but we can call the Cubit's method
                                  context
                                      .read<AppCubits>()
                                      .servicePage(service);
                                },
                              );
                            },
                          ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: AppText(text: 'Close'),
                            onPressed: () {
                              context.read<AppCubits>().goHome();
                            },
                          )
                        ])
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      print("Device Name: ${nameController.text}");
    });
  }
}
