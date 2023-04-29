import 'dart:ui';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:audio_session/audio_session.dart';

class SoundPlayer {
  FlutterSoundPlayer? _soundPlayer;
  bool _isPlayerInitialized = false;

  bool get isPlaying => _soundPlayer!.isPlaying;

  Future initPlayer() async {
    _soundPlayer = FlutterSoundPlayer();

    await _soundPlayer!.openAudioSession();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _isPlayerInitialized = true;
  }

  Future disposePlayer() async {
    if (!_isPlayerInitialized) return;

    await _soundPlayer!.closeAudioSession();
    _soundPlayer = null;
    _isPlayerInitialized = false;
  }

  Future _play(String path, VoidCallback whenFinished) async {
    if (!_isPlayerInitialized) return;

    await _soundPlayer!.startPlayer(
        fromURI: path, codec: Codec.defaultCodec, whenFinished: whenFinished);
  }

  Future _stopPlaying() async {
    if (!_isPlayerInitialized) return;

    await _soundPlayer!.stopPlayer();
  }

  Future togglePlay(String path, bool play, VoidCallback whenFinished) async {
    if (play) {
      await _play(path, whenFinished);
    } else {
      await _stopPlaying();
    }
  }
}
