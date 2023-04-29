import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import 'features/notes_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: NotesList()),
          ],
        ),
      ),
      floatingActionButton: Consumer(
        builder: (ctx, ref, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.newNote).then((_) {
                    ref.read(notesProvider.notifier).refreshNotes();
                  });
                },
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(Routes.newAudioNote)
                      .then((_) {
                    ref.read(notesProvider.notifier).refreshNotes();
                  });
                },
                child: const Icon(Icons.mic),
              ),
            ],
          );
        },
      ),
    );
  }
}
