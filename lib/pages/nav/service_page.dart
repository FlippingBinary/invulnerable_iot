import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      print("Service Name: ${nameController.text}");
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: BlocBuilder<AppCubits, CubitStates>(
          builder: (context, state) {
            final service = (state as ServiceState).service;
            nameController.text = service.name;
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
                        AppLargeText(text: "Service Details"),
                        SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          onEditingComplete: () {
                            final updatedService =
                                service.copyWith(name: nameController.text);
                            context
                                .read<AppCubits>()
                                .updateService(updatedService);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: service.isKnown,
                              onChanged: (value) {
                                final updatedService =
                                    service.copyWith(isKnown: value);
                                context
                                    .read<AppCubits>()
                                    .updateService(updatedService);
                              },
                            ),
                            AppText(text: "I know this service"),
                          ],
                        ),
                        TextField(
                          controller: TextEditingController(text: service.type),
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Type',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: TextEditingController(
                              text: "${service.ip}:${service.port}"),
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Address',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: TextEditingController(text: service.host),
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Hostname',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          ElevatedButton(
                            child: AppText(text: 'Close'),
                            onPressed: () {
                              context.read<AppCubits>().devicePage(service: service);
                            },
                          )
                        ])
                      ],
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
