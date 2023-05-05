import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          final services = (state as PrimaryState).devices;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: AppLargeText(text: "Friendly Spy Detector"),
              ),
              SizedBox(height: 40),
              Expanded(
                child: services.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(services[index].name),
                            onTap: () {
                              BlocProvider.of<AppCubits>(context)
                                  .detailPage(services[index]);
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
