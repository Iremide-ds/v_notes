import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/sound_recorder.dart';

class CreateAudioNote extends ConsumerStatefulWidget {
  const CreateAudioNote({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateAudioNote> createState() => _CreateAudioNoteState();
}

class _CreateAudioNoteState extends ConsumerState<CreateAudioNote> {
  SoundRecorder? _audioRecorder;

  bool get _isRecording => _audioRecorder!.isRecording;

  @override
  void initState() {
    super.initState();
    _audioRecorder = SoundRecorder(ref);
    _audioRecorder!.initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    _audioRecorder!.disposeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                await _audioRecorder!.toggleRecording();
                setState(() {});
              },
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'STOP' : 'START'),
            )
          ],
        ),
      ),
    );
  }
}
