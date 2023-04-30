import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final theme = Theme.of(context);

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _notes.isEmpty
            ? const Center(
                child: Text('No Notes yet!'),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5.sw / 1.sh,
                ),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final currentIndex = _notes[index];

                  return GestureDetector(
                    onTap: () {
                      if (currentIndex.isAudio) {
                        if (_currentlyPlaying != currentIndex.id ||
                            _currentlyPlaying == null) {
                          _audioPlayer!.togglePlay(
                            currentIndex.audioPath!,
                            true,
                            () {
                              setState(() {
                                _currentlyPlaying = null;
                              });
                            },
                          );
                          setState(() {
                            _currentlyPlaying = currentIndex.id;
                          });
                        } else {
                          _audioPlayer!.togglePlay(
                            currentIndex.audioPath!,
                            false,
                            () {
                              setState(() {
                                _currentlyPlaying = null;
                              });
                            },
                          );
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
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(18.0.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 0.05.sh,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          currentIndex.title,
                                          style: theme.textTheme.labelLarge,
                                          overflow: TextOverflow.fade,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .read(notesProvider.notifier)
                                          .deleteNote(currentIndex.id);
                                      ref
                                          .read(notesProvider.notifier)
                                          .refreshNotes();
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 18.0.r),
                              child: currentIndex.isAudio
                                  ? Icon(_currentlyPlaying == currentIndex.id
                                      ? Icons.stop
                                      : Icons.play_arrow_rounded)
                                  : Text(
                                      currentIndex.content,
                                      style: theme.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _notes.length,
              );
  }
}
