import 'package:flutter/material.dart';

class FadeInImagePlaceholder extends StatelessWidget {
  final ImageProvider image;
  final Widget placeholder;
  final Duration duration;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final double? width;
  final double? height;

  const FadeInImagePlaceholder({
    required this.image,
    this.placeholder =
        const DecoratedBox(decoration: BoxDecoration(color: Colors.grey)),
    this.duration = const Duration(milliseconds: 150),
    this.switchInCurve = Curves.easeIn,
    this.switchOutCurve = Curves.easeOut,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheImage(image, context),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {
          child = Image(
            image: image,
            fit: BoxFit.contain,
            width: width,
            height: height,
          );
        } else {
          child = placeholder;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }
}
