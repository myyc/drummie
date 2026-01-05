import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sequencer_provider.dart';
import '../theme/dark_theme.dart';
import 'step_row.dart';

class StepSequencer extends StatelessWidget {
  const StepSequencer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SequencerProvider>(
      builder: (context, sequencer, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step numbers header
            Row(
              children: [
                const SizedBox(width: 56), // Offset for track labels
                Expanded(
                  child: Row(
                    children: List.generate(sequencer.stepCount, (i) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: i % 4 == 0
                                  ? DrummieTheme.textPrimary
                                  : DrummieTheme.textSecondary,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Track rows
            ...List.generate(sequencer.pattern.tracks.length, (trackIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: StepRow(
                  track: sequencer.pattern.tracks[trackIndex],
                  trackIndex: trackIndex,
                  currentStep: sequencer.currentStep,
                  isPlaying: sequencer.isPlaying,
                  onToggleStep: sequencer.toggleStep,
                  onToggleMute: sequencer.toggleTrackMute,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
