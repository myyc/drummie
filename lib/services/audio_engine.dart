import 'package:flutter/services.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import '../models/pattern.dart';

class EffectsSettings {
  double delayTime;
  double delayFeedback;
  double delayMix;
  double reverbSize;
  double reverbDamp;
  double reverbMix;
  double pitch;

  EffectsSettings({
    this.delayTime = 0.3,
    this.delayFeedback = 0.3,
    this.delayMix = 0.0,
    this.reverbSize = 0.5,
    this.reverbDamp = 0.5,
    this.reverbMix = 0.0,
    this.pitch = 1.0,
  });
}

class AudioEngine {
  final SoLoud _soloud = SoLoud.instance;
  final Map<int, AudioSource> _sources = {};
  bool _initialized = false;
  final EffectsSettings effects = EffectsSettings();

  bool get isInitialized => _initialized;

  Future<void> init(Pattern pattern) async {
    if (_initialized) return;

    await _soloud.init();

    // Load all samples
    for (int i = 0; i < pattern.tracks.length; i++) {
      try {
        final assetPath = pattern.tracks[i].samplePath;
        final bytes = await rootBundle.load(assetPath);
        final source = await _soloud.loadMem(
          assetPath,
          bytes.buffer.asUint8List(),
        );
        _sources[i] = source;
      } catch (e) {
        // Sample not found - skip
      }
    }

    // Initialize global filters
    _soloud.filters.echoFilter.activate();
    _soloud.filters.freeverbFilter.activate();

    _initialized = true;
  }

  void updateEffects() {
    if (!_initialized) return;

    // Update echo/delay
    _soloud.filters.echoFilter.wet.value = effects.delayMix;
    _soloud.filters.echoFilter.delay.value = effects.delayTime;
    _soloud.filters.echoFilter.decay.value = effects.delayFeedback;

    // Update reverb
    _soloud.filters.freeverbFilter.wet.value = effects.reverbMix;
    _soloud.filters.freeverbFilter.roomSize.value = effects.reverbSize;
    _soloud.filters.freeverbFilter.damp.value = effects.reverbDamp;
  }

  Future<void> triggerTrack(int trackIndex, {double volume = 1.0}) async {
    final source = _sources[trackIndex];
    if (source == null) return;

    try {
      final handle = await _soloud.play(
        source,
        volume: volume,
      );
      // Apply pitch shift
      _soloud.setRelativePlaySpeed(handle, effects.pitch);
    } catch (e) {
      // Ignore playback errors
    }
  }

  Future<void> triggerStep(Pattern pattern, int stepIndex) async {
    for (int i = 0; i < pattern.tracks.length; i++) {
      final track = pattern.tracks[i];
      if (!track.muted && track.steps[stepIndex]) {
        triggerTrack(i, volume: track.volume);
      }
    }
  }

  Future<void> dispose() async {
    if (!_initialized) return;

    _soloud.filters.echoFilter.deactivate();
    _soloud.filters.freeverbFilter.deactivate();

    for (var source in _sources.values) {
      await _soloud.disposeSource(source);
    }
    _sources.clear();

    _soloud.deinit();
    _initialized = false;
  }
}
