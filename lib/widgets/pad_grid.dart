import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sequencer_provider.dart';
import 'drum_pad.dart';

class PadGrid extends StatelessWidget {
  const PadGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SequencerProvider>(
      builder: (context, sequencer, _) {
        final tracks = sequencer.pattern.tracks;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];
            return DrumPad(
              label: track.shortName,
              isActive: sequencer.isPlaying &&
                  track.steps[sequencer.currentStep],
              onTap: () => sequencer.triggerPad(index),
            );
          },
        );
      },
    );
  }
}
