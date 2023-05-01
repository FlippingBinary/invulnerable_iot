import 'package:nsd/nsd.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/model/data_model.dart';

class AppCubits extends Cubit<CubitStates> {
  final List<DataModel> services = [];
  final serviceNameDiscovery = '_services._dns-sd._udp';
  final serviceNameHTTP = '_http._tcp';

  AppCubits() : super(WelcomeState());

  // From Home page, start scanning for devices
  startDeviceScan() async {
    try {
      emit(HomeState(services));
      // services
      //     .add(DataModel(name: 'Device 1', type: 'type 1', host: 'host 1', port: 'port 1'));
      // emit(HomeState(services));
      final Discovery discovery = await startDiscovery(serviceNameHTTP);
      discovery.addServiceListener((service, serviceStatus) async {
        if (serviceStatus == ServiceStatus.found) {
          final DataModel serviceData = DataModel.fromService(service);
          if (!services.contains(serviceData)) {
            print(
                'Found service: ${service.toString()} ${serviceStatus.toString()}}');
            services.add(serviceData);
            if (state is HomeState) {
              emit(HomeState([]));
              emit(HomeState(services));
            }
          }
        }
      });
    } catch (e) {
      emit(WelcomeState());
    }
  }

  detailPage(DataModel service) {
    emit(DetailState(service));
  }

  goHome() {
    emit(HomeState(services));
  }

  goHomeAndStartDeviceScan() async {
    await startDeviceScan();
    // emit(HomeState(services));
  }
}
