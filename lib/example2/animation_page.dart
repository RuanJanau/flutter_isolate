// ignore_for_file: library_private_types_in_public_api, avoid_print, depend_on_referenced_packages, non_constant_identifier_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_isolate/example2/isolate_fibonacci.dart';

class StaggerAnimation extends StatelessWidget {
  var _buildAnimation;

  StaggerAnimation({Key? key, required this.controller})
      : opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: 150.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 150.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 16.0),
          end: const EdgeInsets.only(bottom: 75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = Tween<BorderRadius>(
          begin: BorderRadius.circular(4.0),
          end: BorderRadius.circular(75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = Tween<Color>(
          begin: Colors.indigo[100],
          end: Colors.orange[400],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.500,
              0.750,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius> borderRadius;
  final Animation<Color> color;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class StaggerDemo extends StatefulWidget {
  const StaggerDemo({super.key});

  @override
  _StaggerDemoState createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);

    _playAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 10.0; // 1.0 is normal animation speed.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  print('####################################################');
                  print('Start SEM isolate: ${DateTime.now()}');
                  print('Fibonacci SEM -> ${Calc.fibonacci(42)}');
                  print('Finish SEM isolate: ${DateTime.now()}');
                },
                child: const Text('Calc Fibonacci'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('####################################################');
                  print('Start COM isolate: ${DateTime.now()}');
                  print(
                    'Fibonacci COM isolate-> ${await Calc().isolateFibonacci(42)}',
                  );
                  print('Finish COM isolate: ${DateTime.now()}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Calc Fibonacci Isolate'),
              )
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _playAnimation();
            },
            child: Center(
              child: Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                child: StaggerAnimation(controller: _controller.view),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
