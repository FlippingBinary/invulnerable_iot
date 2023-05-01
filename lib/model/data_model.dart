import 'package:nsd/nsd.dart';

class DataModel {
  String name;
  String type;
  String host;
  String port;

  DataModel({
    required this.name,
    required this.type,
    required this.host,
    required this.port,
  });

  factory DataModel.fromService(Service service) => DataModel(
        name: service.name ?? 'unknown',
        type: service.type ?? 'unknown',
        host: service.host ?? 'unknown',
        port: service.port != null ? '${service.port}' : 'unknown',
  );
}
