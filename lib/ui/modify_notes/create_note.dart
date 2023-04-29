import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:v_notes/constants.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({Key? key}) : super(key: key);

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int? _createdId;

  void _saveNote() async {
    final notifier = ProviderScope.containerOf(context, listen: false)
        .read(notesProvider.notifier);

    if (_createdId != null) {
      await notifier.updateNote(
          _contentController.text, _titleController.text, _createdId!);
    } else {
      setState(() {
        _createdId =
            notifier.createNote(_contentController.text, _titleController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

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
