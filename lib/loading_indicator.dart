import 'dart:async';
import 'dart:ui';
import 'dart:math' as Math;
import 'package:flutter/widgets.dart';

class DefaultLoadingIndicator extends StatefulWidget {
  final Color color;

  const DefaultLoadingIndicator({
    this.color = const Color(0x99000000),
  });

  @override
  _DefaultLoadingIndicatorState createState() =>
      _DefaultLoadingIndicatorState();
}

class _DefaultLoadingIndicatorState extends State<DefaultLoadingIndicator> {
  final leavesCount = 12;
  Timer timer;
  double rotateDegree = 0;
  Paint paint;
  final leaveColors = <Color>[];
  final Path path = Path();

  @override
  void initState() {
    super.initState();
    _initLeavesColors();
    _initPaint();
    timer = Timer.periodic(Duration(milliseconds: 50), (_) {
      setState(() {
        rotateDegree += 30;
        rotateDegree %= 360;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(30, 30),
      painter: _DefaultIndicatorPainter(
        paint,
        widget.color,
        leavesCount,
        leaveColors,
        path,
        rotateDegree,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void _initPaint() {
    paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
  }

  void _initLeavesColors() {
    Color startColor = widget.color;
    Color endColor = Color(widget.color.value & 0x00FFFFFF | 0x11000000);
    for (int i = 0; i < leavesCount; i++) {
      double fraction = 1 - i * 30 / 360;
      leaveColors.add(_evaluate(fraction, startColor, endColor));
    }
  }

  Color _evaluate(double fraction, Color startValue, Color endValue) {
    int startInt = startValue.value;
    double startA = ((startInt >> 24) & 0xff) / 255.0;
    double startR = ((startInt >> 16) & 0xff) / 255.0;
    double startG = ((startInt >> 8) & 0xff) / 255.0;
    double startB = (startInt & 0xff) / 255.0;
    int endInt = endValue.value;
    double endA = ((endInt >> 24) & 0xff) / 255.0;
    double endR = ((endInt >> 16) & 0xff) / 255.0;
    double endG = ((endInt >> 8) & 0xff) / 255.0;
    double endB = (endInt & 0xff) / 255.0;
    // convert from sRGB to linear
    startR = Math.pow(startR, 2.2);
    startG = Math.pow(startG, 2.2);
    startB = Math.pow(startB, 2.2);
    endR = Math.pow(endR, 2.2);
    endG = Math.pow(endG, 2.2);
    endB = Math.pow(endB, 2.2);
    // compute the interpolated color in linear space
    double a = startA + fraction * (endA - startA);
    double r = startR + fraction * (endR - startR);
    double g = startG + fraction * (endG - startG);
    double b = startB + fraction * (endB - startB);
    // convert back to sRGB in the [0..255] range
    a = a * 255.0;
    r = Math.pow(r, 1.0 / 2.2) * 255.0;
    g = Math.pow(g, 1.0 / 2.2) * 255.0;
    b = Math.pow(b, 1.0 / 2.2) * 255.0;
    return Color(
        a.round() << 24 | r.round() << 16 | g.round() << 8 | b.round());
  }
}

class _DefaultIndicatorPainter extends CustomPainter {
  final Paint p;
  final Color color;
  final leavesCount;
  final leaveColors;
  final Path path;
  final double rotateDegree;

  _DefaultIndicatorPainter(
    this.p,
    this.color,
    this.leavesCount,
    this.leaveColors,
    this.path,
    this.rotateDegree,
  );

  @override
  void paint(Canvas canvas, Size size) {
    _drawFlower(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _drawFlower(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.width / 2);
    canvas.rotate(rotateDegree * Math.pi / 180);
    canvas.save();
    double leafWidth = size.width / 12;
    path.reset();
    Rect rect = Rect.fromLTRB(
        -leafWidth / 2, -size.width / 2, leafWidth / 2, -size.width / 4);
    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(leafWidth / 2));
    path.addRRect(rRect);
    path.close();
    for (int i = 0; i < leavesCount; i++) {
      Color color = leaveColors[i];
      p.color = color;
      canvas.drawPath(path, p);
      canvas.rotate(-30 * Math.pi / 180);
    }
    canvas.restore();
  }
}
