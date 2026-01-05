import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sequencer_provider.dart';
import '../theme/dark_theme.dart';

class TransportBar extends StatelessWidget {
  const TransportBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SequencerProvider>(
      builder: (context, sequencer, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: DrummieTheme.surface,
            border: Border(
              bottom: BorderSide(color: DrummieTheme.surfaceLight),
            ),
          ),
          child: Row(
            children: [
              // Logo
              const Text(
                'DRUMMIE',
                style: TextStyle(
                  color: DrummieTheme.accent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              // Play/Stop buttons
              _TransportButton(
                icon: Icons.play_arrow,
                isActive: sequencer.isPlaying,
                onPressed: sequencer.isPlaying ? null : sequencer.play,
              ),
              const SizedBox(width: 8),
              _TransportButton(
                icon: Icons.stop,
                isActive: !sequencer.isPlaying,
                onPressed: sequencer.isPlaying ? sequencer.stop : null,
              ),
              const SizedBox(width: 24),
              // BPM control
              const Text(
                'BPM',
                style: TextStyle(
                  color: DrummieTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: TextEditingController(text: '${sequencer.bpm}'),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: DrummieTheme.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    filled: true,
                    fillColor: DrummieTheme.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    final bpm = int.tryParse(value);
                    if (bpm != null) {
                      sequencer.setBpm(bpm);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 150,
                child: Slider(
                  value: sequencer.bpm.toDouble(),
                  min: 40,
                  max: 300,
                  onChanged: (value) => sequencer.setBpm(value.round()),
                ),
              ),
              const SizedBox(width: 24),
              // Clear button
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: DrummieTheme.textSecondary,
                onPressed: sequencer.clearPattern,
                tooltip: 'Clear pattern',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TransportButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onPressed;

  const _TransportButton({
    required this.icon,
    required this.isActive,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? DrummieTheme.accent : DrummieTheme.surfaceLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: isActive ? DrummieTheme.background : DrummieTheme.textSecondary,
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
