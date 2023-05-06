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
          final devices = (state as PrimaryState)
              .devices
              .where((device) => device.isAdopted == false)
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
                child: state.devices.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: devices.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(devices[index].name),
                            onTap: () {
                              BlocProvider.of<AppCubits>(context)
                                  .devicePage(device: devices[index]);
                            },
                          );
                        },
                      ),
              ),
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
