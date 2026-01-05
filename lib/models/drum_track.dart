class DrumTrack {
  final String name;
  final String shortName;
  final String samplePath;
  final List<bool> steps;
  double volume;
  bool muted;

  DrumTrack({
    required this.name,
    required this.shortName,
    required this.samplePath,
    int stepCount = 16,
    this.volume = 1.0,
    this.muted = false,
  }) : steps = List.filled(stepCount, false);

  void toggleStep(int index) {
    if (index >= 0 && index < steps.length) {
      steps[index] = !steps[index];
    }
  }

  void clearSteps() {
    for (int i = 0; i < steps.length; i++) {
      steps[i] = false;
    }
  }
}
