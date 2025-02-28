import 'package:flutter/material.dart';
import 'package:gyropic/model/gyro.dart';

class ImageContainer extends StatefulWidget {
  final ValueNotifier<Gyro> gyroNotifier;

  const ImageContainer({super.key, required this.gyroNotifier});

  @override
  // ignore: library_private_types_in_public_api
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Gyro>(
      valueListenable: widget.gyroNotifier,
      builder: (context, gyro, child) {
        return SizedBox(
          height: 350,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(100, 253, 81, 249),
                  blurRadius: 5.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/luffy.jpg', fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
