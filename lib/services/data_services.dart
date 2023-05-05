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
          // final serviceDiscovery = await startDiscovery(serviceIdentifier);
          // serviceDiscovery.addServiceListener(_createServiceListener(callback));
          // discoveries[serviceIdentifier] = serviceDiscovery;
          // callback(serviceData);
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  };
}

ServiceListener _createServiceListener(Function callback) {
  return (service, status) async {
    try {
      print("Found a service: ${service.toString()}");
      if (status == ServiceStatus.found && service.addresses != null) {
        final serviceData = DataModel.fromService(service);
        callback(serviceData);
      }
    } catch (e, s) {
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
    final discovery =
        await startDiscovery(serviceNameDiscovery, autoResolve: false);

    discovery.addServiceListener(_createDiscoveryListener(this, callback));

    // print("Deep scan of the network has been requested");
    // final subnet = await _getSubnet();
    // print("Subnet is $subnet");

    // // iterate each possible port number
    // for (var host = 1; host < 255; host++) {
    //   print("Scanning '$subnet.$host' for services");

    //   // iterate each IP address in the subnet
    //   final List<Future<DataModel?>> scanners = [];
    //   for (var port = 1; port <= 1024; port++) {
    //     // TODO: This assumes the subnet is class C. It should be more flexible.
    //     final String ip = '$subnet.$host';
    //     scanners.add(_checkService(ip, port));
    //     await Future.delayed(Duration(milliseconds: 1));
    //   }
    //   print("Waiting for results");
    //   await Future.forEach(scanners, (scanner) async {
    //     var result = await scanner;
    //     if (result != null) {
    //       callback(result);
    //     }
    //   });
    //   print("Done waiting for results");
    // }

    print("No results should follow.");
    // return DataServices._fromConnection(discoveries);
    // return DataServices._fromConnection(discoveries);

    // final wrapper = DataServices._fromConnection(discovery);
    // _finalizer.attach(wrapper, wrapper);

    // return wrapper;
  }

  // Create a function that identifies a specific service
  void identifyService(String serviceIdentifier, Function callback) async {
    print("Identifying service $serviceIdentifier");
    final serviceDiscovery =
        await startDiscovery(serviceIdentifier, ipLookupType: IpLookupType.v4);
    serviceDiscovery.addServiceListener(_createServiceListener(callback));
    _discoveries[serviceIdentifier] = serviceDiscovery;
  }

  void stopScanning() {
    for (var discovery in _discoveries.values) {
      stopDiscovery(discovery);
    }
  }
}
