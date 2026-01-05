import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/sequencer_provider.dart';
import 'theme/dark_theme.dart';
import 'widgets/effects_panel.dart';
import 'widgets/pad_grid.dart';
import 'widgets/step_sequencer.dart';
import 'widgets/transport_bar.dart';

void main() {
  runApp(const DrummieApp());
}

class DrummieApp extends StatelessWidget {
  const DrummieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SequencerProvider()..init(),
      child: MaterialApp(
        title: 'Drummie',
        debugShowCheckedModeBanner: false,
        theme: DrummieTheme.theme,
        home: const DrummiePage(),
      ),
    );
  }
}

class DrummiePage extends StatelessWidget {
  const DrummiePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TransportBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Desktop layout: side by side
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sequencer
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(title: 'STEP SEQUENCER'),
                              const SizedBox(height: 8),
                              const StepSequencer(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Pads + Effects
                        SizedBox(
                          width: 280,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(title: 'LIVE PADS'),
                              const SizedBox(height: 8),
                              const PadGrid(),
                              const SizedBox(height: 16),
                              const EffectsPanel(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  // Mobile/narrow layout: stacked
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(title: 'LIVE PADS'),
                      const SizedBox(height: 8),
                      const PadGrid(),
                      const SizedBox(height: 16),
                      const EffectsPanel(),
                      const SizedBox(height: 24),
                      _SectionHeader(title: 'STEP SEQUENCER'),
                      const SizedBox(height: 8),
                      const StepSequencer(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: DrummieTheme.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }
}
