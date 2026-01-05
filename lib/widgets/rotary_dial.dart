import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/dark_theme.dart';

class RotaryDial extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String? unit;

  const RotaryDial({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.unit,
  });

  @override
  State<RotaryDial> createState() => _RotaryDialState();
}

class _RotaryDialState extends State<RotaryDial> {
  double? _startY;
  double? _startValue;

  double get _normalizedValue =>
      (widget.value - widget.min) / (widget.max - widget.min);

  void _onPanStart(DragStartDetails details) {
    _startY = details.localPosition.dy;
    _startValue = widget.value;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_startY == null || _startValue == null) return;

    final delta = _startY! - details.localPosition.dy;
    final range = widget.max - widget.min;
    final sensitivity = range / 100;
    final newValue = (_startValue! + delta * sensitivity)
        .clamp(widget.min, widget.max);

    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: DrummieTheme.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          child: CustomPaint(
            size: const Size(48, 48),
            painter: _DialPainter(
              value: _normalizedValue,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.unit != null
              ? '${widget.value.toStringAsFixed(widget.max > 10 ? 0 : 2)}${widget.unit}'
              : widget.value.toStringAsFixed(2),
          style: const TextStyle(
            color: DrummieTheme.textPrimary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _DialPainter extends CustomPainter {
  final double value;

  _DialPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background circle
    final bgPaint = Paint()
      ..color = DrummieTheme.surface
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Border
    final borderPaint = Paint()
      ..color = DrummieTheme.surfaceLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Arc showing value (from 135° to 405°, i.e., 270° range)
    const startAngle = 135 * math.pi / 180;
    const sweepRange = 270 * math.pi / 180;
    final sweepAngle = sweepRange * value;

    final arcPaint = Paint()
      ..color = DrummieTheme.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Indicator dot
    final indicatorAngle = startAngle + sweepAngle;
    final dotRadius = radius - 8;
    final dotCenter = Offset(
      center.dx + dotRadius * math.cos(indicatorAngle),
      center.dy + dotRadius * math.sin(indicatorAngle),
    );

    final dotPaint = Paint()
      ..color = DrummieTheme.accent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(dotCenter, 4, dotPaint);

    // Center dot
    final centerDotPaint = Paint()
      ..color = DrummieTheme.surfaceLight
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, centerDotPaint);
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) => oldDelegate.value != value;
}
