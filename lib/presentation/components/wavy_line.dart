import 'package:flutter/material.dart';

import 'package:hotspot_host_questionnaire/core/color_palette.dart';

class WavyLine extends StatelessWidget {
  final Size size;
  final double progress;

  const WavyLine({super.key, required this.size, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: WavyLinePainter(progress), size: size);
  }
}

class WavyLinePainter extends CustomPainter {
  final double progress;

  WavyLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double filledWidth = size.width * progress;

    double waveHeight = 4;
    double waveLength = 18;

    final path = Path()..moveTo(0, size.height / 2);

    for (double x = 0; x < size.width; x += waveLength) {
      path.quadraticBezierTo(
        x + waveLength / 4,
        size.height / 2 - waveHeight,
        x + waveLength / 2,
        size.height / 2,
      );
      path.quadraticBezierTo(
        x + 3 * waveLength / 4,
        size.height / 2 + waveHeight,
        x + waveLength,
        size.height / 2,
      );
    }

    final purple = Paint()
      ..color = ColorPalette.progressColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final white = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Purple section
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, filledWidth, size.height));
    canvas.drawPath(path, purple);
    canvas.restore();

    // White section
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(filledWidth, 0, size.width - filledWidth, size.height),
    );
    canvas.drawPath(path, white);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
