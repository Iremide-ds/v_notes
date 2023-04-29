import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v_notes/constants.dart';
import 'package:v_notes/data/models/note_model.dart';

class EditNote extends StatefulWidget {
  final int noteId;

  const EditNote({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  State createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Note? currentNote;

  void _saveNote() async {
    final notifier = ProviderScope.containerOf(context, listen: false)
        .read(notesProvider.notifier);

    if (currentNote != null) {
      await notifier.updateNote(
          _contentController.text, _titleController.text, currentNote!.id);
    }
  }

  void _initNote() {
    currentNote = ProviderScope.containerOf(context, listen: false)
        .read(notesProvider.notifier)
        .fetchNote(widget.noteId);

    if (currentNote != null) {
      _titleController.text = currentNote!.title;
      _contentController.text = currentNote!.content;
    }
  }

  @override
  void initState() {
    super.initState();

    _initNote();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(actions: [
          TextButton(onPressed: () => _saveNote(), child: const Text('save'))
        ]),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                ),
                TextFormField(
                  controller: _contentController,
                ),
              ],
            ),
          ),
        ));
  }
}
