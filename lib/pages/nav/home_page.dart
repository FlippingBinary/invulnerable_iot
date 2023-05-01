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
    TabController tabController = TabController(length: 4, vsync: this);
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          var services = (state as LoadedState).services;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row(
                  children: [
                    Icon(Icons.menu, size: 30, color: Colors.black),
                    Expanded(child: Container()),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: AppLargeText(text: "Discover"),
              ),
              SizedBox(height: 40),
              SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    labelPadding: const EdgeInsets.only(left: 20, right: 20),
                    controller: tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey.withOpacity(0.6),
                    isScrollable: true,
                    // indicatorSize: TabBarIndicatorSize.label,
                    indicator: CircleTabIndicator(
                        color: theme.primaryColor, radius: 3),
                    tabs: [
                      Tab(text: "All"),
                      Tab(text: "Devices"),
                      Tab(text: "Learning"),
                      Tab(text: "Advice"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                // Set height to the screen minutes the height of the app bar and tab bar.
                // TODO: This should dynamically check the height of other elements.
                height: MediaQuery.of(context).size.height - 369,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<AppCubits>(context)
                                .detailPage(services[ index ]);
                          },
                          child: Text(services[index].name),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(services[index].name);
                      },
                    ),
                    ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(services[index].name);
                      },
                    ),
                    ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(services[index].name);
                      },
                    ),
                  ],
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
