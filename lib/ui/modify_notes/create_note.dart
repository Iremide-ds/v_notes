import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  Future<void> _saveNote() async {
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
        )
      ]),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.01.sh),
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
      ),
    );
  }
}
