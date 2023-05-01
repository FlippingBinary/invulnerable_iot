import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/services/data_services.dart';
import 'package:invulnerable_iot/widgets/app_large_text.dart';
import 'package:invulnerable_iot/widgets/app_text.dart';
import 'package:invulnerable_iot/widgets/responsive_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  // List pages = [
  // {
  //   image: "group.png",
  //   title: "Friendly Spy Detector",
  //   subtitle: "makes your home safer",
  //   description: "We're excited to have you here! Our app is designed to help you keep your network safe and secure. With just a few taps, you can scan your network for insecure devices and get guidance on how to update them or mitigate the risk if an update is not available.",
  // }
  // ]
  List images = [
    "group.png",
    "mobile.png",
    "family.png",
  ];
  List titles = [
    "Friendly Spy Detector",
    "Scan Your Network",
    "Improve Your Security",
  ];
  List subtitles = [
    "makes your home safer",
    "to discover insecure devices",
    "with our expert guidance",
  ];
  List descriptions = [
    "We're excited to have you here! Our app is designed to help you keep your network safe and secure. With just a few taps, you can scan your network for insecure devices and get guidance on how to update them or mitigate the risk if an update is not available.",
    "With our app, you can easily scan your home network for insecure devices that could be putting your data at risk. Our app will provide you with a detailed report on any vulnerabilities found, and guide you through the steps needed to secure your devices. Stay one step ahead of hackers and keep your data safe with our app.",
    "If an update for a device is not available, our app will provide you with guidance on how to mitigate the risk. This may include changing your network settings or temporarily disabling the device. Our app will help you make informed decisions about your network security, and give you peace of mind knowing that you are taking steps to protect your data. Let's get started!",
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        // set _currentIndex to the current page number
        _currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: images.length,
              itemBuilder: (_, index) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double imageHeight = constraints.maxHeight / 2;
                    if (constraints.maxHeight >= constraints.maxWidth * 2) {
                      imageHeight = constraints.maxWidth;
                    }
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: imageHeight,
                            width: constraints.maxWidth,
                            color: Colors.transparent,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.asset(
                                "assets/images/${images[index]}",
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              padding: EdgeInsets.all(16.0),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppLargeText(
                                      text: titles[index],
                                    ),
                                    AppLargeText(
                                      text: subtitles[index],
                                      color:
                                          theme.primaryColor.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: AppText(
                                        text: descriptions[index],
                                        color: theme.hintColor,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                        onPressed: () async {
                                          BlocProvider.of<AppCubits>(context)
                                              .getData();
                                        },
                                        child: Text("Press me")),
                                    ResponsiveButton(width: 100),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // generate three dots to illustrate which page the user is on
              children: List.generate(3, (indexDots) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 2, right: 4),
                  width: 8,
                  height: _currentIndex == indexDots ? 16 : 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _currentIndex == indexDots
                        ? theme.primaryColor
                        : theme.primaryColor.withOpacity(0.5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
