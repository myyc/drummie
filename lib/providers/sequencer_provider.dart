import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/pattern.dart';
import '../services/audio_engine.dart';

class SequencerProvider extends ChangeNotifier {
  final AudioEngine _audioEngine = AudioEngine();
  late Pattern _pattern;
  int _bpm = 120;
  int _currentStep = 0;
  bool _isPlaying = false;
  Timer? _timer;

  SequencerProvider() {
    _pattern = Pattern(name: 'Pattern 1');
  }

  Pattern get pattern => _pattern;
  int get bpm => _bpm;
  int get currentStep => _currentStep;
  bool get isPlaying => _isPlaying;
  int get stepCount => _pattern.stepCount;
  AudioEngine get audioEngine => _audioEngine;

  Future<void> init() async {
    await _audioEngine.init(_pattern);
  }

  void setBpm(int value) {
    _bpm = value.clamp(40, 300);
    if (_isPlaying) {
      _stopTimer();
      _startTimer();
    }
    notifyListeners();
  }

  void toggleStep(int trackIndex, int stepIndex) {
    _pattern.tracks[trackIndex].toggleStep(stepIndex);
    notifyListeners();
  }

  void togglePlay() {
    if (_isPlaying) {
      stop();
    } else {
      play();
    }
  }

  void play() {
    _isPlaying = true;
    _startTimer();
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _stopTimer();
    _currentStep = 0;
    notifyListeners();
  }

  void triggerPad(int trackIndex) {
    final track = _pattern.tracks[trackIndex];
    _audioEngine.triggerTrack(trackIndex, volume: track.volume);
  }

  void clearPattern() {
    _pattern.clearAll();
    notifyListeners();
  }

  void setTrackVolume(int trackIndex, double volume) {
    _pattern.tracks[trackIndex].volume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  void toggleTrackMute(int trackIndex) {
    _pattern.tracks[trackIndex].muted = !_pattern.tracks[trackIndex].muted;
    notifyListeners();
  }

  // Effects setters
  void setDelayTime(double value) {
    _audioEngine.effects.delayTime = value;
    _audioEngine.updateEffects();
    notifyListeners();
  }

  void setDelayFeedback(double value) {
    _audioEngine.effects.delayFeedback = value;
    _audioEngine.updateEffects();
    notifyListeners();
  }

  void setDelayMix(double value) {
    _audioEngine.effects.delayMix = value;
    _audioEngine.updateEffects();
    notifyListeners();
  }

  void setReverbSize(double value) {
    _audioEngine.effects.reverbSize = value;
    _audioEngine.updateEffects();
    notifyListeners();
  }

  void setReverbDamp(double value) {
    _audioEngine.effects.reverbDamp = value;
    _audioEngine.updateEffects();
    notifyListeners();
  }

  void setReverbMix(double value) {
    _audioEngine.effects.reverbMix = value;
    _audioEngine.updateEffects();
    notifyListeners();
  }

  void setPitch(double value) {
    _audioEngine.effects.pitch = value;
    notifyListeners();
  }

  void _startTimer() {
    final intervalMs = (60000 / _bpm / 4).round(); // 16th notes
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _tick();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _tick() {
    _audioEngine.triggerStep(_pattern, _currentStep);
    notifyListeners();
    _currentStep = (_currentStep + 1) % _pattern.stepCount;
  }

  @override
  void dispose() {
    _stopTimer();
    _audioEngine.dispose();
    super.dispose();
  }
}
