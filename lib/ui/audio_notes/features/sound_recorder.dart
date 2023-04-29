import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';

import '../../../constants.dart';

class SoundRecorder {
  final WidgetRef ref;

  SoundRecorder(this.ref);

  FlutterSoundRecorder? _soundRecorder;

  bool _isRecorderInitialized = false;

  bool get isRecording => _soundRecorder!.isRecording;

  Future<String> _getDir() async {
    final docsDir = await getApplicationDocumentsDirectory();

    final audioDirFolder = Directory('${docsDir.path}/$audioFolder/');

    if (await audioDirFolder.exists()) {
      return audioDirFolder.path;
    } else {
      final audioDirNewFolder = await audioDirFolder.create(recursive: true);
      return audioDirNewFolder.path;
    }
  }

  Future<String> _generateFilePath() async {
    final root = await _getDir();

    return '$root${DateFormat('yyyy_MM_dd_hh_mm_ss').format(DateTime.now())}.mp4';
  }

  Future initRecorder() async {
    _soundRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _soundRecorder!.openAudioSession();

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

    _isRecorderInitialized = true;
  }

  Future disposeRecorder() async {
    if (!_isRecorderInitialized) return;

    await _soundRecorder!.closeAudioSession();
    _soundRecorder = null;
    _isRecorderInitialized = false;
  }

  Future _record() async {
    if (!_isRecorderInitialized) return;

    final filePath = await _generateFilePath();

    await _soundRecorder!.startRecorder(toFile: filePath, codec: Codec.aacMP4);
    ref.read(notesProvider.notifier).createAudioNote(filePath, 'New Audio');
  }

  Future _stopRecording() async {
    if (!_isRecorderInitialized) return;

    await _soundRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_soundRecorder!.isStopped) {
      await _record();
    } else {
      await _stopRecording();
    }
  }
}
