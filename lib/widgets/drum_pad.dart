import 'package:flutter/material.dart';
import '../theme/dark_theme.dart';

class DrumPad extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const DrumPad({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<DrumPad> createState() => _DrumPadState();
}

class _DrumPadState extends State<DrumPad> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        widget.onTap();
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        decoration: BoxDecoration(
          color: _pressed
              ? DrummieTheme.accent
              : widget.isActive
                  ? DrummieTheme.accentDim
                  : DrummieTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: DrummieTheme.accent.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: DrummieTheme.accent.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: _pressed ? DrummieTheme.background : DrummieTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
