import 'package:flutter/material.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List images = [
    "security.png",
    "scan.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/${images[index]}"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLargeText(text: "Trips", color: Colors.white),
                          AppText(
                              text: "Security", size: 30, color: Colors.blue),
                          SizedBox(height: 20),
                          Container(
                              width: 250,
                              child: AppText(
                                text:
                                    "Mountain hikes give you an incredible sense of freedom along with endurance test",
                                color: Colors.white,
                              ))
                        ]),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
