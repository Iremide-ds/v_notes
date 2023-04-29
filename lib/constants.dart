import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'data/state_management/database_notifier.dart';
import 'data/models/note_model.dart';
import 'data/state_management/notes_notifier.dart';
import 'ui/home/home_screen.dart';
import 'ui/modify_notes/create_note.dart';
import 'ui/audio_notes/create_audio_note.dart';
import 'ui/modify_notes/edit_note.dart';

class Routes {
  static const String home = '/';
  static const String newNote = '/new';
  static const String newAudioNote = '/new_audio';
  static const String editNote = '/edit';

  static final Map<String, WidgetBuilder> routes = {
    home: (_) => const HomeScreen(),
    newNote: (_) => const CreateNote(),
    newAudioNote: (_) => const CreateAudioNote()
  };

  static MaterialPageRoute Function(RouteSettings settings) onGenerateRoute = (RouteSettings settings) {
    assert(settings.name == editNote);

    return MaterialPageRoute(
        builder: (ctx) => EditNote(noteId: settings.arguments as int));
  };
}

const String notesDB = 'notes_test2.db';
const String tableName = 'notes_test2';
const String audioFolder = 'audios_test';

// List of all providers
final dbProvider = StateNotifierProvider<DatabaseNotifier, Database?>(
    (ref) => DatabaseNotifier());

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
    (ref) => NotesNotifier(ref));
