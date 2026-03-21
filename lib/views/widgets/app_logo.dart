// lib/views/widgets/app_logo.dart
// Star Pulse Logo — adaptive colors for light and dark mode

import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showName;
  final bool showTag;

  const AppLogo({
    super.key,
    this.size = 90,
    this.showName = false,
    this.showTag = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: _StarPulsePainter(),
        ),
        if (showName) ...[
          SizedBox(height: size * 0.12),
          Text(
            'HEALTHFIT',
            style: TextStyle(
              color: textColor,
              fontSize: size * 0.22,
              fontWeight: FontWeight.w800,
              letterSpacing: size * 0.04,
            ),
          ),
        ],
        if (showTag) ...[
          const SizedBox(height: 4),
          Text(
            'PREMIUM HEALTH',
            style: TextStyle(
              color: goldColor,
              fontSize: size * 0.09,
              fontWeight: FontWeight.w600,
              letterSpacing: size * 0.04,
            ),
          ),
        ],
      ],
    );
  }
}

class _StarPulsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final scale = w / 160.0;

    // ── Background rounded square ─────────────────────────────────────────
    final bgPaint = Paint()..color = const Color(0xFF111111);
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.225),
    );
    canvas.drawRRect(bgRect, bgPaint);

    // Outer gold border
    final outerBorder = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.01;
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.01, h * 0.01, w * 0.98, h * 0.98),
      Radius.circular(w * 0.22),
    );
    canvas.drawRRect(outerRect, outerBorder);

    // Inner subtle border
    final innerBorder = Paint()
      ..color = AppColors.gold.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.004;
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.038, h * 0.038, w * 0.924, h * 0.924),
      Radius.circular(w * 0.194),
    );
    canvas.drawRRect(innerRect, innerBorder);

    // ── Star shape ────────────────────────────────────────────────────────
    Path starPath(List<Offset> pts) {
      final path = Path();
      final scaled =
          pts.map((p) => Offset(p.dx * scale, p.dy * scale)).toList();
      path.moveTo(scaled[0].dx, scaled[0].dy);
      for (int i = 1; i < scaled.length; i++) {
        path.lineTo(scaled[i].dx, scaled[i].dy);
      }
      path.close();
      return path;
    }

    final outerStar = [
      const Offset(80, 18),
      const Offset(96, 46),
      const Offset(128, 42),
      const Offset(108, 66),
      const Offset(118, 98),
      const Offset(88, 82),
      const Offset(80, 112),
      const Offset(72, 82),
      const Offset(42, 98),
      const Offset(52, 66),
      const Offset(32, 42),
      const Offset(64, 46),
    ];

    // Star fill
    canvas.drawPath(
        starPath(outerStar), Paint()..color = const Color(0xFF1A1A1A));

    // Star gold stroke
    canvas.drawPath(
      starPath(outerStar),
      Paint()
        ..color = AppColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.01
        ..strokeJoin = StrokeJoin.round,
    );

    // Inner star subtle ring
    final innerStar = [
      const Offset(80, 26),
      const Offset(94, 50),
      const Offset(122, 46),
      const Offset(104, 67),
      const Offset(113, 95),
      const Offset(86, 81),
      const Offset(80, 103),
      const Offset(74, 81),
      const Offset(47, 95),
      const Offset(56, 67),
      const Offset(38, 46),
      const Offset(66, 50),
    ];
    canvas.drawPath(
      starPath(innerStar),
      Paint()
        ..color = AppColors.gold.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.004,
    );

    // ── Pulse line ────────────────────────────────────────────────────────
    final pulsePoints = [
      const Offset(48, 72),
      const Offset(58, 72),
      const Offset(65, 56),
      const Offset(74, 88),
      const Offset(81, 64),
      const Offset(88, 72),
      const Offset(95, 72),
      const Offset(101, 62),
      const Offset(107, 72),
      const Offset(112, 72),
    ];

    final pulsePath = Path();
    pulsePath.moveTo(pulsePoints[0].dx * scale, pulsePoints[0].dy * scale);
    for (int i = 1; i < pulsePoints.length; i++) {
      pulsePath.lineTo(pulsePoints[i].dx * scale, pulsePoints[i].dy * scale);
    }

    canvas.drawPath(
      pulsePath,
      Paint()
        ..color = AppColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.016
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
