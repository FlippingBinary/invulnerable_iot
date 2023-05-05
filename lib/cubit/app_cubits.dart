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
        print('Found a service: ${dataModel.toString()}');
        // Find an existing device with a service that has the same IP as the new service
        // If it exists, check to see if that device already has the new service
        // If it does, augment missing data in the existing service with the new service
        // If it does not, add the new service to the existing device
        // If it does not exist, add the new service to the list of known devices
        for (var newService in dataModel.services) {
          final String newIdentifier = newService.identifier;
          if (devices.any((device) => device.services
              .any((service) => service.ip == newService.ip))) {
            print("Found an existing device with the same IP");
            final DataModel existingDevice = devices.firstWhere(
                (device) => device.services.any((service) => service.ip == newService.ip));
            if (existingDevice.services.any((service) => service.identifier == newIdentifier)) {
              final ServiceModel existingService = existingDevice.services
                  .firstWhere((service) => service.identifier == newService.identifier);
              existingService.merge(newService);
            } else {
              existingDevice.services = [
                ...existingDevice.services,
                ...dataModel.services
              ];
            }
          } else {
            print("Found a new device: $dataModel");
            devices.add(dataModel);
          }
        }
      });
      // final Discovery discovery = await startDiscovery(serviceNameHTTP);
      // discovery.addServiceListener((service, serviceStatus) async {
      //   if (serviceStatus == ServiceStatus.found) {
      //     final DataModel serviceData = await createDataModelFromService(service);
      //     if (!services.any((e) =>
      //         e.host == serviceData.host && e.port == serviceData.port)) {
      //       print(
      //           'Found a service: ${service.toString()} ${serviceStatus.toString()}}');
      //       services.add(serviceData);
      //       if (state is PrimaryState) {
      //         emit(PrimaryState([]));
      //         emit(PrimaryState(services));
      //       }
      //     } else {
      //       print('Found a duplicate service: ${service.toString()}');
      //     }
      //   }
      // });

      // print("Iterating interfaces");
      // var interfaces =
      //     await NetworkInterface.list(type: InternetAddressType.IPv4);
      // final List<Future<DeviceScanResult?>> scanners = [];
      // // iterate each possible port number
      // for (var port = 1; port <= 65535; port++) {
      //   // iterate each IP address in the subnet
      //   for (var interface in interfaces) {
      //     for (var addr in interface.addresses) {
      //       final String ip = addr.address;
      //       final String subnet = ip.substring(0, ip.lastIndexOf('.'));
      //       for (var i = 1; i < 255; i++) {
      //         final String host = '$subnet.$i';
      //         scanners.add(_checkService(host, port));
      //       }
      //     }
      //   }
      // }

      // print("Waiting for results");
      // final List<DeviceScanResult?> results = await Future.wait(scanners);
      // for (var result in results) {
      //   if (result != null) {
      //     print('Found unknown service at ${ result.ip }:${ result.port }: ${ result.header }');
      //     services.add(DataModel(
      //       name: 'Service at ${ result.ip }:${ result.port }',
      //       type: 'unknown',
      //       host: result.ip,
      //       port: result.port.toString(),
      //     ));
      //     if (state is PrimaryState) {
      //       emit(PrimaryState([]));
      //       emit(PrimaryState(services));
      //     }
      //   }
      // }
    } catch (e, s) {
      print('Error while scanning for devices: $e');
      print('Stacktrace: $s');
      emit(WelcomeState());
    }
  }

  detailPage(DataModel service) {
    emit(DetailState(service));
  }

  goHome() {
    emit(PrimaryState(devices));
  }

  goHomeAndStartDeviceScan() async {
    await startDeviceScan();
    // emit(HomeState(services));
  }
}
