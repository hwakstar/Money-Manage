import 'package:flutter/material.dart';

class PageLayout extends StatelessWidget {
  final Widget? child;
  final double lineHeiht;

  const PageLayout({Key? key, this.child, this.lineHeiht = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PagePainter(lineHeiht),
      child: getWidget(child),
    );
  }

  Widget? getWidget(Widget? child) {
    if (child != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 30),
        child: child,
      );
    }
    return null;
  }
}

class PagePainter extends CustomPainter {
  final double marginTop = 0;
  final double marginLeft = 20;
  final double marginBottom = 30;
  final double lineHeight;
  double drawnHeight = 0;
  PagePainter(this.lineHeight);
  @override
  void paint(Canvas canvas, Size size) {
    if (size == Size.zero) {
      return;
    }
    final paintBg = Paint()..color = Colors.white;
    var rrectRed = RRect.fromLTRBR(
        0, 0, size.width, size.height, const Radius.circular(0));
    canvas.drawRRect(rrectRed, paintBg);
    Paint marginPaint = Paint()
      ..color = const Color(0xFF7F7FFF)
      ..strokeWidth = 1;
    final Paint linePaint = Paint()
      ..color = const Color(0x55b4b4b4)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(marginLeft, marginTop),
        Offset(size.width, marginTop), marginPaint);
    marginPaint.strokeWidth = 1.75;
    canvas.drawLine(Offset(marginLeft, marginTop + 3),
        Offset(size.width, marginTop + 3), marginPaint);
    drawnHeight = marginTop + 3 + 1.5;

    do {
      drawnHeight += lineHeight;
      canvas.drawLine(Offset(marginLeft, drawnHeight),
          Offset(size.width, drawnHeight), linePaint);
    } while (drawnHeight + lineHeight < size.height - marginBottom);
  }

  @override
  bool shouldRepaint(covariant PagePainter oldDelegate) {
    return false;
  }
}
