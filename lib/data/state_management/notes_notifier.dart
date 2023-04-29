import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'database_notifier.dart';
import '../models/note_model.dart';
import '../../constants.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  final StateNotifierProviderRef<NotesNotifier, List<Note>> ref;

  NotesNotifier(this.ref) : super([]);

  Database? get db => ref.watch(dbProvider);

  DatabaseNotifier get dbNotifier => ref.read(dbProvider.notifier);

  Future<bool> fetchExistingNotes() async {
    try {
      await dbNotifier.initDB();

      // Query the table for all Notes.
      final List<Map<String, dynamic>> results =
          await db!.query(tableName, orderBy: 'id');

      state = List.generate(results.length, (i) {
        debugPrint(results[i].toString());
        return Note(
          id: results[i]['id'],
          title: results[i]['title'],
          content: results[i]['content'],
          audioPath: results[i]['audio_path'],
          isAudio: (results[i]['is_audio'] == 'true') ? true : false,
        );
      });

      return true;
    } on Exception catch (_, e) {
      debugPrintStack(stackTrace: e);
      return false;
    }
  }

  Future refreshNotes() async {
    try {
      // Query the table for all Notes.
      final List<Map<String, dynamic>> results =
          await db!.query(tableName, orderBy: 'id');

      state = [];
      state = List.generate(results.length, (i) {
        debugPrint(results[i].toString());
        return Note(
          id: results[i]['id'],
          title: results[i]['title'],
          content: results[i]['content'],
          audioPath: results[i]['audio_path'],
          isAudio: (results[i]['is_audio'] == 'true') ? true : false,
        );
      });

      return true;
    } on Exception catch (_, e) {
      debugPrintStack(stackTrace: e);
      return false;
    }
  }

  int newNoteId() {
    if (state.isEmpty) {
      return 0;
    } else {
      return state.last.id + 1;
    }
  }

  Future<bool> _noteExists(int id) async {
    final List<Map<String, dynamic>> results =
        await db!.query(tableName, where: 'id = ?', whereArgs: [id]);

    return results.isNotEmpty;
  }

  void _insertIntoDB(Map<String, dynamic> map) async {
    await db!
        .insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _updateInDB(Map<String, dynamic> map) async {
    await db!.update(
      tableName,
      map,
      where: 'id = ?',
      whereArgs: [map['id']],
    );
  }

  void _removeFromDB(int noteId) async {
    await db!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  int? createNote(String content, String title) {
    if (content.isEmpty && title.isEmpty) return null;

    final id = newNoteId();
    final newNote =
        Note(id: id, content: content, title: title, isAudio: false);
    _insertIntoDB(newNote.toMap());
    return id;
  }

  Future<void> updateNote(String content, String title, int id) async {
    if (content.isEmpty && title.isEmpty) {
      _removeFromDB(id);
    } else {
      final existingNote =
          Note(id: id, content: content, title: title, isAudio: false);
      if (await _noteExists(id)) {
        _updateInDB(existingNote.toMap());
      } else {
        _insertIntoDB(existingNote.toMap());
      }
    }
  }

  void createAudioNote(String filePath, String title) {
    final newAudioNote =
        Note(id: newNoteId(), title: title, content: '', isAudio: true, audioPath: filePath);
    _insertIntoDB(newAudioNote.toMap());
  }

  Note? fetchNote(int noteId) {
    try {
      final note = state.firstWhere((element) => element.id == noteId);

      return note;
    } on Exception catch (_, e) {
      debugPrintStack(stackTrace: e);
    }
    return null;
  }
}
