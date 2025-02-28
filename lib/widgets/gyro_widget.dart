import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gyropic/model/gyro.dart';
import 'package:gyropic/widgets/image_cointainer.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroWidget extends StatefulWidget {
  const GyroWidget({super.key});

  @override
  State<GyroWidget> createState() => _GyroWidgetState();
}

class _GyroWidgetState extends State<GyroWidget>
    with SingleTickerProviderStateMixin {
  late StreamSubscription
  _gyroscopeSubscription; //subscription for listen to gyroscope event
  late AnimationController _controller;
  late Animation<Gyro> _animation;
  final ValueNotifier<Gyro> _gyro = ValueNotifier(
    Gyro(x: 0.0, y: 0.0, z: 0.0),
  ); //notfier to update the ui

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    ); //initialisation of animation controller

    _animation = GyroTween(begin: _gyro.value, end: _gyro.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    ); //initialisation of animation
    //listen to gyroscope event
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      Gyro newGyro = Gyro(x: event.x * 0.2, y: event.y * 0.2, z: event.z * .3);
      //updating animation with new values
      _animation = GyroTween(
        begin: _gyro.value,
        end: newGyro,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller.forward(from: 0.0); //restarting the animation
      //updating gyro notifier
      _gyro.value = newGyro;
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.002) //perspective
                ..rotateX(
                  _animation.value.x,
                ) //Rotation on x axis based of gyro notifier x axis value
                ..rotateY(
                  _animation.value.y,
                ), //Rotation on y axis based of gyro notifier y axis value
          child: ImageContainer(gyroNotifier: _gyro),
        );
      },
    );
  }
}

//custome gyrotween for smooth animation
class GyroTween extends Tween<Gyro> {
  GyroTween({required Gyro begin, required Gyro end})
    : super(begin: begin, end: end);

  @override
  Gyro lerp(double t) {
    return Gyro(
      //liner interpolation
      x: begin!.x + (end!.x - begin!.x) * t,
      y: begin!.y + (end!.y - begin!.y) * t,
      z: begin!.z + (end!.z - begin!.z) * t,
    );
  }
}
