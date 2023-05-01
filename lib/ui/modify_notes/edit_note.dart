import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Future<void> _saveNote() async {
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
          TextButton(
            onPressed: () {
              _saveNote().then((_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Saved!'),
                  ));
                }
              });
            },
            child: const Text('Save'),
          ),
        ]),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      prefixStyle: Theme.of(context).textTheme.labelMedium,
                      prefixText: 'Title: ',
                      hintText: 'No Title',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
                SizedBox(
                  height: 0.05.sh,
                  width: 1.sw,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Content',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
