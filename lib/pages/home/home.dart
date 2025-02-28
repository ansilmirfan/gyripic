import 'package:flutter/material.dart';
import 'package:gyropic/widgets/gyro_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: GyroWidget()),
    );
  }
}
