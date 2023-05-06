import 'dart:convert';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:invulnerable_iot/model/data_model.dart';
import 'package:nsd/nsd.dart';

const serviceNameDiscovery = '_services._dns-sd._udp';
const serviceNameHTTP = '_http._tcp';

// Define a class to hold ip, port, and header information
class SniffedService {
  String ip;
  int port;
  String header;
  SniffedService({
    required this.ip,
    required this.port,
    required this.header,
  });
  @override
  String toString() {
    return 'SniffedService{ip: $ip, port: $port, header: $header}';
  }
}

Future<SniffedService?> _checkService(String ip, int port) async {
  try {
    final socket =
        await Socket.connect(ip, port, timeout: Duration(seconds: 1));
    final data = await socket.first;
    socket.destroy();
    print("Found service at $ip:$port");
    return SniffedService(
      ip: ip,
      port: port,
      header: utf8.decode(data),
    );
  } on SocketException catch (_) {
    return null;
  } catch (e) {
    return null;
  }
}

// Define a function that takes a callback and returns a function that takes two arguments
// The first argument is called service and the second is called status
// That function will be async and return void
typedef ServiceListener = void Function(Service service, ServiceStatus status);

ServiceListener _createDiscoveryListener(
    DataServices dataServices, Function callback) {
  return (service, status) async {
    try {
      if (status == ServiceStatus.found) {
        if (service.name != null && service.type != null) {
          // The service identifier will be the service name with the service type appended up to the first dot.
          final serviceName = service.name!;
          final serviceType =
              service.type!.substring(0, service.type!.indexOf('.'));
          final serviceIdentifier = '$serviceName.$serviceType';
          print("Found a service type: $serviceIdentifier");
          dataServices.identifyService(serviceIdentifier, callback);
        }
      }
    } catch (e, s) {
      print("_createDiscoveryListener error:");
      print(e);
      print(s);
    }
  };
}

ServiceListener _createServiceListener(Function callback) {
  return (service, status) async {
    try {
      print("Received service from NSD: ${service.toString()}");
      if (status == ServiceStatus.found && service.addresses != null) {
        final serviceData = DataModel.fromService(service);
        callback(serviceData);
      }
    } catch (e, s) {
      print("_createServiceListener error:");
      print(e);
      print(s);
    }
  };
}

// Create a DataServices class that scans the network for services
class DataServices {
  // static final Finalizer<DataServices> _finalizer =
  //     Finalizer<DataServices>((services) => services.stopScanning());
  final Map<String, Discovery> _discoveries = {};
  DataServices();

  // Create a function that scans the network for services
  discoverServices(Function callback) async {
    try {
      if (_discoveries.containsKey(serviceNameDiscovery)) {
        print("Already scanning the network for services");
        return;
      }
      final discovery =
          await startDiscovery(serviceNameDiscovery, autoResolve: false);

      discovery.addServiceListener(_createDiscoveryListener(this, callback));
      _discoveries[serviceNameDiscovery] = discovery;
      print("Now there are ${_discoveries.length} discoveries");
    } catch (e, s) {
      print("discoverServices error:");
      print(e);
      print(s);
    }
  }

  // Create a function that identifies a specific service
  void identifyService(String serviceIdentifier, Function callback) async {
    try {
      if (_discoveries.containsKey(serviceIdentifier)) {
        print("Already scanning for service $serviceIdentifier");
        return;
      }
      print("Identifying service $serviceIdentifier");
      final serviceDiscovery = await startDiscovery(serviceIdentifier,
          ipLookupType: IpLookupType.v4);
      serviceDiscovery.addServiceListener(_createServiceListener(callback));
      _discoveries[serviceIdentifier] = serviceDiscovery;
      print("Now there are ${_discoveries.length} discoveries");
    } catch (e, s) {
      print("identifyService error:");
      print(e);
      print(s);
    }
  }

  void pauseScanning() async {
    // Iterate the key and value pairs of the discoveries map
    for (var key in _discoveries.keys) {
      try {
        if (_discoveries[key] == null) {
          print("No discovery for $key when trying to pause it!");
          continue;
        }
        await stopDiscovery(_discoveries[key]!);
      } catch (e, s) {
        print("stopScanning error when attempting to stop `$key`:");
        print(e);
        print(s);
      }
    }
  }

  void resumeScanning() async {
    for (var key in _discoveries.keys) {
      try {
        final discovery = await startDiscovery(key);
        _discoveries[key] = discovery;
      } catch (e, s) {
        print("resumeScanning error:");
        print(e);
        print(s);
      }
    }
  }
}
