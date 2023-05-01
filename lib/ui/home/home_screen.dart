import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import 'features/notes_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        scrolledUnderElevation: 1.0,
        toolbarHeight: 0.094.sh,
        title: Text(
          'My Notes',
          style: theme.textTheme.displayMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Consumer(
                      builder: (ctx, ref, child) {
                        return Container(
                          padding: EdgeInsets.all(18.r),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.newNote)
                                      .then((_) {
                                    ref
                                        .read(notesProvider.notifier)
                                        .refreshNotes();
                                    Navigator.of(ctx).pop();
                                  });
                                },
                                leading: const Icon(Icons.add),
                                title: const Text('New Note'),
                              ),
                              SizedBox(
                                height: 0.01.sh,
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.newAudioNote)
                                      .then((_) {
                                    ref
                                        .read(notesProvider.notifier)
                                        .refreshNotes();
                                    Navigator.of(ctx).pop();
                                  });
                                },
                                leading: const Icon(Icons.mic),
                                title: const Text('New Recording'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Container(
        height: 1.sh,
        width: 1.sw,
        padding: EdgeInsets.symmetric(vertical: 0.009.sh, horizontal: 0.022.sw),
        child: const Column(
          children: [
            Expanded(child: NotesList()),
          ],
        ),
      ),
    );
  }
}
