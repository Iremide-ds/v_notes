import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../data/models/note_model.dart';
import 'sound_player.dart';

class NotesList extends ConsumerStatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  ConsumerState<NotesList> createState() => _NotesListState();
}

class _NotesListState extends ConsumerState<NotesList> {
  SoundPlayer? _audioPlayer;
  int? _currentlyPlaying;

  bool _isLoading = true;

  List<Note> get _notes => ref.watch(notesProvider);

  bool get _isPlaying => _audioPlayer!.isPlaying;

  void _fetchNotes() async {
    ref.read(notesProvider.notifier).fetchExistingNotes().then((value) {
      setState(() {
        _isLoading = !value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchNotes();
    _audioPlayer = SoundPlayer();
    _audioPlayer!.initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer!.disposePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _notes.isEmpty
            ? const Center(
                child: Text('No Notes yet!'),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final currentIndex = _notes[index];

                  return ListTile(
                    title: Text(currentIndex.title),
                    subtitle: Text(currentIndex.content),
                    trailing: currentIndex.isAudio
                        ? const Icon(Icons.play_arrow_rounded)
                        : null,
                    onTap: () {
                      if (currentIndex.isAudio) {
                        if (_currentlyPlaying != currentIndex.id ||
                            _currentlyPlaying == null) {
                          _audioPlayer!
                              .togglePlay(currentIndex.audioPath!, true, () {
                            setState(() {
                              _currentlyPlaying = null;
                            });
                          },);
                          setState(() {
                            _currentlyPlaying = currentIndex.id;
                          });
                        } else {
                          _audioPlayer!
                              .togglePlay(currentIndex.audioPath!, false, () {
                            setState(() {
                              _currentlyPlaying = null;
                            });
                          },);
                          setState(() {
                            _currentlyPlaying = null;
                          });
                        }
                      } else {
                        Navigator.of(context)
                            .pushNamed(Routes.editNote,
                                arguments: currentIndex.id)
                            .then((_) {
                          ref.read(notesProvider.notifier).refreshNotes();
                        });
                      }
                    },
                  );
                },
                itemCount: _notes.length,
              );
  }
}
