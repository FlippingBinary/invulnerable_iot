import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';
import 'package:invulnerable_iot/pages/nav/main_page.dart';

class HomePage extends StatefulWidget {
  final IntCallback gotoTab;
  const HomePage({super.key, required this.gotoTab});

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
          final strangeDevices = (state as PrimaryState)
              .devices
              .where((device) => !device.isAdopted)
              .toList();
          final deviceUpdates = (state as PrimaryState)
              .devices
              .where((device) =>
                  device.isAdopted &&
                  device.services.any((service) => !service.isKnown))
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
                child: InkWell(
                  onTap: () {
                    if (strangeDevices.isNotEmpty) {
                      widget.gotoTab(1);
                    } else if (deviceUpdates.isNotEmpty) {
                      widget.gotoTab(2);
                    } else {
                      widget.gotoTab(3);
                    }
                  },
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // The Icon should be sentiment_satisfied if there are no strange devices and no device updates
                        // The Icon should be sentiment_dissatisfied if there are strange devices or device updates
                        if (strangeDevices.isNotEmpty &&
                            deviceUpdates.isNotEmpty) {
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            size: constraints.maxWidth * 0.5,
                            color: theme.colorScheme.error,
                          );
                        } else if (strangeDevices.isNotEmpty) {
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            size: constraints.maxWidth * 0.5,
                            color: theme.colorScheme.error,
                          );
                        } else if (deviceUpdates.isNotEmpty) {
                          return Icon(
                            Icons.sentiment_satisfied,
                            size: constraints.maxWidth * 0.5,
                          );
                        } else {
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            size: constraints.maxWidth * 0.5,
                            color: theme.colorScheme.primary,
                          );
                        }
                        return Icon(
                          Icons.sentiment_satisfied,
                          size: constraints.maxWidth * 0.5,
                          color: unAdoptedDevices.isNotEmpty
                              ? theme.colorScheme.error
                              : null,
                        );
                      },
                    ),
                  ),
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
