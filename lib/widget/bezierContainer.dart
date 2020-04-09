import 'dart:math';

import 'package:fireflyapp/widget/theme_gradient.dart' as app_styling;
import 'package:flutter/material.dart';

import 'customClipper.dart';

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: -pi / 3.5,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height * .4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: app_styling.themeGradient(context),
          ),
        ),
      ),
    ));
  }
}
