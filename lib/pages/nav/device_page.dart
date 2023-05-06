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
  void initState() {
    super.initState();
    nameController.addListener(() {
      print("Name: ${nameController.text}");
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: BlocBuilder<AppCubits, CubitStates>(
          builder: (context, state) {
            final device = (state as DeviceState).device;
            nameController.text = device.name;
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
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
                            final updatedDevice = device.copyWith(name: nameController.text);
                            context.read<AppCubits>().updateDevice(updatedDevice);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: device.services.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: device.services.length,
                              itemBuilder: (_, i) {
                                return ListTile(
                                  leading: Icon(Icons.star),
                                  title: Text(
                                    device.services[i].ip,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    // We can't emit from here, but we can call the Cubit's method
                                    context.read<AppCubits>().goHome();
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
