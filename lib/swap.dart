import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final double widgetATop = 20;
  final double widgetBTop = 110;
  bool swapped = false;

  late AnimationController controller;
  late Animation<double> addressAnimation;
  animationListener() => setState(() {});

  @override
  Widget build(BuildContext context) {
    var tweenValue = addressAnimation.value;

    return SizedBox(
      width: 300,
      height: 150,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: widgetATop + tweenValue,
            left: 20,
            child: const Text("This is widget A"),
          ),
          // Widget B
          Positioned(
            top: widgetBTop - tweenValue,
            left: 20,
            child: const Text("This is widget B"),
          ),
          // Swap button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => setState(() {
                swapped ? controller.reverse() : controller.forward();
                swapped = !swapped;
              }),
              child: const Text("swap"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    addressAnimation = Tween(
      begin: 0.0,
      end: widgetBTop - widgetATop,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ))
      ..addListener(animationListener);
  }

  @override
  dispose() {
    // Dispose of animation controller
    controller.dispose();
    super.dispose();
  }
}
