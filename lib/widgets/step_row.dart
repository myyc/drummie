import 'package:flutter/material.dart';
import '../models/drum_track.dart';
import '../theme/dark_theme.dart';

class StepRow extends StatelessWidget {
  final DrumTrack track;
  final int trackIndex;
  final int currentStep;
  final bool isPlaying;
  final Function(int trackIndex, int stepIndex) onToggleStep;
  final Function(int trackIndex) onToggleMute;

  const StepRow({
    super.key,
    required this.track,
    required this.trackIndex,
    required this.currentStep,
    required this.isPlaying,
    required this.onToggleStep,
    required this.onToggleMute,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Track label + mute
        GestureDetector(
          onTap: () => onToggleMute(trackIndex),
          child: Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: track.muted
                  ? DrummieTheme.stepInactive
                  : DrummieTheme.surfaceLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                track.shortName,
                style: TextStyle(
                  color: track.muted
                      ? DrummieTheme.textSecondary
                      : DrummieTheme.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Steps
        Expanded(
          child: Row(
            children: List.generate(track.steps.length, (stepIndex) {
              final isActive = track.steps[stepIndex];
              final isPlayhead = isPlaying && stepIndex == currentStep;
              final isDownbeat = stepIndex % 4 == 0;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: GestureDetector(
                    onTap: () => onToggleStep(trackIndex, stepIndex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive
                            ? (isPlayhead
                                ? DrummieTheme.playhead
                                : DrummieTheme.stepActive)
                            : (isPlayhead
                                ? DrummieTheme.accent.withValues(alpha: 0.3)
                                : isDownbeat
                                    ? DrummieTheme.surfaceLight
                                    : DrummieTheme.stepInactive),
                        borderRadius: BorderRadius.circular(4),
                        border: isPlayhead
                            ? Border.all(color: DrummieTheme.playhead, width: 2)
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
