import 'dart:io';

import 'package:nsd/nsd.dart';

class ServiceModel {
  String? type;
  String? host;
  String ip;
  String port;
  String? header;
  bool isKnown;

  ServiceModel({
    this.type,
    this.host,
    required this.ip,
    required this.port,
    this.header,
    this.isKnown = false,
  });

  // define identifier getter
  String get identifier => '$ip:$port';

  // define a function that will merge missing info from another service
  void merge(ServiceModel service) {
    type ??= service.type;
    host ??= service.host;
    header ??= service.header;
  }

  @override
  String toString() {
    return 'ServiceModel{type: $type, host: $host, ip: $ip, port: $port, header: $header, isKnown: $isKnown}';
  }
}

class DataModel {
  String name;
  bool isAdopted;
  List<ServiceModel> services;

  DataModel({
    required this.name,
    this.isAdopted = false,
    this.services = const [],
  });

  factory DataModel.fromService(Service service) {
    var ipAddress = 'unknown';
    final List<ServiceModel> services = [];
    Set<String> seen = {};

    // Iterate the service.addresses list and create a ServiceModel for each
    // address. If the address is already in the list, merge the info from the
    // new service into the existing one.
    for (var addr in service.addresses ?? []) {
      if (seen.contains(addr.address)) {
        continue;
      }
      seen.add(addr.address);
      ServiceModel serviceModel = ServiceModel(
        type: service.type,
        host: service.host,
        ip: addr.address,
        port: service.port != null ? '${service.port}' : 'unknown',
      );
      if (ipAddress == 'unknown') {
        ipAddress = addr.address;
      }
      services.add(serviceModel);
    }

    if (services.isEmpty) {
      throw Exception('No addresses found for service: $service');
    }

    return DataModel(
      name: service.name ?? service.host ?? ipAddress,
      services: services,
    );
  }

  List<String> get identifiers {
    return services.map((e) => e.identifier).toList();
  }

  @override
  String toString() {
    return 'DataModel{name: $name, isAdopted: $isAdopted, services: $services}';
  }
}

// Future<DataModel?> createDataModelFromService(Service service) async {
//   try {
//     print("createDataModelFromService($service)");
//     if (service.host == null ||
//         service.port == null ||
//         service.addresses == null) {
//       return null;
//     }
//     return DataModel.fromService(service);
//   } catch (e, s) {
//     print("Error while creating data model from service: $e");
//     print("Stacktrace: $s");
//     return null;
//   }
// }
