import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Access context and Cubit here
    final cubit = context.read<AppCubits>();

    if (state == AppLifecycleState.resumed) {
      await cubit.resume();
    } else {
      await cubit.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        buildWhen: (previous, current) =>
            (previous as PrimaryState).devices.length !=
            (current as PrimaryState).devices.length,
        builder: (context, state) {
          ThemeData theme = Theme.of(context);
          final adoptedDevices = (state as PrimaryState)
              .devices
              .where((device) => device.isAdopted)
              .toList();
          final unAdoptedDevices = (state as PrimaryState)
              .devices
              .where((device) => !device.isAdopted)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: AppLargeText(text: "Invulnerable IOT"),
              ),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: AppText(
                    text: "Keep track of devices on your network, get alerts "
                        "when new devices join, and when they have firmware "
                        "updates to keep your network more secure."),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).size.width < 600 ? 2 : 4,
                  children: [
                    InkWell(
                      onTap: () {
                        print("Tapped Unadopted Devices");
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Icon(
                                      Icons.settings_remote,
                                  size: 75,
                                  color: unAdoptedDevices.isNotEmpty
                                      ? theme.colorScheme.error
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: unAdoptedDevices.isNotEmpty
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      '${unAdoptedDevices.length}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSecondary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text('Strange Devices'),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Tapped Known Devices");
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Icon(
                                      Icons.sentiment_satisfied,
                                  size: 75,
                                  color: unAdoptedDevices.isNotEmpty
                                      ? theme.colorScheme.error
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: unAdoptedDevices.isNotEmpty
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      '${unAdoptedDevices.length}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSecondary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text('Known Devices'),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Tapped Unadopted Devices");
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Icon(
                                  unAdoptedDevices.isEmpty
                                      ? Icons.system_security_update_good
                                      : Icons.system_security_update,
                                  size: 75,
                                  color: unAdoptedDevices.isNotEmpty
                                      ? theme.colorScheme.error
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: unAdoptedDevices.isNotEmpty
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      '${unAdoptedDevices.length}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSecondary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text('Unadopted'),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Tapped Unadopted Devices");
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Icon(
                                  unAdoptedDevices.isEmpty
                                      ? Icons.system_security_update_good
                                      : Icons.system_security_update,
                                  size: 75,
                                  color: unAdoptedDevices.isNotEmpty
                                      ? theme.colorScheme.error
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: unAdoptedDevices.isNotEmpty
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      '${unAdoptedDevices.length}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSecondary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text('Unadopted'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;

  CircleTabIndicator({this.color = Colors.grey, this.radius = 3});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  double radius;

  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;
    Offset circleOffset = offset +
        Offset(configuration.size!.width / 2,
            configuration.size!.height - radius - 5);

    canvas.drawCircle(circleOffset, radius, paint);
  }
}
