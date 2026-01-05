import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sequencer_provider.dart';
import '../theme/dark_theme.dart';
import 'rotary_dial.dart';

class EffectsPanel extends StatelessWidget {
  const EffectsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SequencerProvider>(
      builder: (context, sequencer, _) {
        final effects = sequencer.audioEngine.effects;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DrummieTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: DrummieTheme.surfaceLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'EFFECTS',
                style: TextStyle(
                  color: DrummieTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Delay section
                  _EffectSection(
                    title: 'DELAY',
                    children: [
                      RotaryDial(
                        label: 'TIME',
                        value: effects.delayTime,
                        min: 0.05,
                        max: 1.0,
                        unit: 's',
                        onChanged: (v) => sequencer.setDelayTime(v),
                      ),
                      const SizedBox(height: 8),
                      RotaryDial(
                        label: 'FDBK',
                        value: effects.delayFeedback,
                        min: 0.0,
                        max: 0.9,
                        onChanged: (v) => sequencer.setDelayFeedback(v),
                      ),
                      const SizedBox(height: 8),
                      RotaryDial(
                        label: 'MIX',
                        value: effects.delayMix,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (v) => sequencer.setDelayMix(v),
                      ),
                    ],
                  ),
                  // Reverb section
                  _EffectSection(
                    title: 'REVERB',
                    children: [
                      RotaryDial(
                        label: 'SIZE',
                        value: effects.reverbSize,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (v) => sequencer.setReverbSize(v),
                      ),
                      const SizedBox(height: 8),
                      RotaryDial(
                        label: 'DAMP',
                        value: effects.reverbDamp,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (v) => sequencer.setReverbDamp(v),
                      ),
                      const SizedBox(height: 8),
                      RotaryDial(
                        label: 'MIX',
                        value: effects.reverbMix,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (v) => sequencer.setReverbMix(v),
                      ),
                    ],
                  ),
                  // Pitch section
                  _EffectSection(
                    title: 'PITCH',
                    children: [
                      RotaryDial(
                        label: 'SHIFT',
                        value: effects.pitch,
                        min: 0.5,
                        max: 2.0,
                        unit: 'x',
                        onChanged: (v) => sequencer.setPitch(v),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EffectSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _EffectSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: DrummieTheme.accent,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}
