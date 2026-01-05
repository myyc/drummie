import 'drum_track.dart';

class Pattern {
  final String name;
  final List<DrumTrack> tracks;
  final int stepCount;

  Pattern({
    required this.name,
    this.stepCount = 16,
  }) : tracks = _createDefaultTracks(stepCount);

  static List<DrumTrack> _createDefaultTracks(int stepCount) {
    final trackDefs = [
      ('Kick', 'KCK', 'kick.wav'),
      ('Snare', 'SNR', 'snare.wav'),
      ('Hi-Hat Closed', 'HHC', 'hihat_closed.wav'),
      ('Hi-Hat Open', 'HHO', 'hihat_open.wav'),
      ('Clap', 'CLP', 'clap.wav'),
      ('Rim', 'RIM', 'rim.wav'),
      ('Tom Low', 'TML', 'tom_low.wav'),
      ('Tom Mid', 'TMM', 'tom_mid.wav'),
      ('Tom High', 'TMH', 'tom_high.wav'),
      ('Crash', 'CRS', 'crash.wav'),
      ('Ride', 'RDE', 'ride.wav'),
      ('Shaker', 'SHK', 'shaker.wav'),
      ('Cowbell', 'COW', 'cowbell.wav'),
      ('Conga', 'CNG', 'conga.wav'),
      ('Bongo', 'BNG', 'bongo.wav'),
      ('Tambourine', 'TMB', 'tambourine.wav'),
    ];

    return trackDefs
        .map((t) => DrumTrack(
              name: t.$1,
              shortName: t.$2,
              samplePath: 'assets/samples/${t.$3}',
              stepCount: stepCount,
            ))
        .toList();
  }

  void clearAll() {
    for (var track in tracks) {
      track.clearSteps();
    }
  }
}
