import 'package:invulnerable_iot/model/data_model.dart';
import 'package:nsd/nsd.dart';

// Create a DataServices class that scans the network for services
class DataServices {
  // Create a list of services
  final serviceNameHTTP = '_http._tcp';
  final serviceNameDiscovery = '_services._dns-sd._udp';

  // Create a function that scans the network for services
  Future<List<DataModel>> getServices({ String serviceName = '_services._dns-sd._udp' }) async {
    final discovery = await startDiscovery(serviceNameHTTP);
    final services = <DataModel>[];

    discovery.addServiceListener((service, status) {
      print('Found service: ${service.toString()} ${status.toString()}}');
      if (status == ServiceStatus.found) {
        services.add(DataModel.fromService(service));
      }
    });

    await Future.delayed(Duration(seconds: 5));
    await stopDiscovery(discovery);

    // Create a variable that stores the scan result
    print('Done.');
    return services;
  }
}
