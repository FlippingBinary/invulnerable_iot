import 'package:invulnerable_iot/services/data_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/model/data_model.dart';

class AppCubits extends Cubit<CubitStates> {
  final DataServices dataServices = DataServices();
  final List<DataModel> devices = [];
  final serviceNameDiscovery = '_services._dns-sd._udp';
  final serviceNameHTTP = '_http._tcp';

  AppCubits() : super(WelcomeState());

  // From Home page, start scanning for devices
  startDeviceScan() async {
    try {
      emit(PrimaryState(devices));

      print("Starting discovery");
      await dataServices.discoverServices((DataModel dataModel) {
        print('Found a device: $dataModel');
        // Find an existing device with a service that has the same IP as the new service
        // If it exists, check to see if that device already has the new service
        // If it does, augment missing data in the existing service with the new service
        // If it does not, add the new service to the existing device
        // If it does not exist, add the new service to the list of known devices
        for (var newService in dataModel.services) {
          final String newIdentifier = newService.identifier;
          if (devices.any((device) =>
              device.services.any((service) => service.ip == newService.ip))) {
            print("Found an existing device with the same IP");
            final DataModel existingDevice = devices.firstWhere((device) =>
                device.services.any((service) => service.ip == newService.ip));
            if (existingDevice.services
                .any((service) => service.identifier == newIdentifier)) {
              final ServiceModel existingService = existingDevice.services
                  .firstWhere(
                      (service) => service.identifier == newService.identifier);
              existingService.merge(newService);
            } else {
              existingDevice.services = [
                ...existingDevice.services,
                ...dataModel.services
              ];
            }
          } else {
            print(
                "Found a new device in discoverServices callback: $dataModel");
            devices.add(dataModel);
          }
        }
        // Using this empty emit to be sure state updates in the next line
        emit(PrimaryState([]));
        emit(PrimaryState(devices));
      });
    } catch (e, s) {
      print('Error while scanning for devices: $e');
      print('Stacktrace: $s');
      emit(WelcomeState());
    }
  }

  devicePage({DataModel? device, ServiceModel? service}) {
    if (device != null) {
      emit(DeviceState(device));
    } else if (service != null) {
      final device = devices.firstWhere(
          (device) => device.services.any((s) => s.uuid == service.uuid));
      emit(DeviceState(device));
    }
  }

  servicePage(ServiceModel service) {
    emit(ServiceState(service));
  }

  goHome() {
    emit(PrimaryState(devices));
  }

  goHomeAndStartDeviceScan() async {
    await startDeviceScan();
    // emit(HomeState(services));
  }

  updateDevice(DataModel device) {
    print("Being asked to update the device");
    // Find the device in the devices list that has the same uuid as the provided device and replace it with the provided device.
    final index = devices.indexWhere((d) => d.uuid == device.uuid);
    if (index != -1) {
      devices[index] = device;
    }
    emit(DeviceState(devices[index]));
  }

  updateService(ServiceModel service) {
    // Find the device in the devices list that has the same uuid as the provided device and replace it with the provided device.
    final device = devices.firstWhere(
        (device) => device.services.any((s) => s.uuid == service.uuid));
    final index = device.services.indexWhere((s) => s.uuid == service.uuid);
    if (index != -1) {
      device.services[index] = service;
    }
    emit(ServiceState(device.services[index]));
  }

  pause() async {
    dataServices.pauseScanning();
  }

  resume() async {
    return dataServices.resumeScanning();
  }
}
