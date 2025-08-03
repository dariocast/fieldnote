import 'dart:io';
import 'package:fieldnote/core/models/note.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseRepository {
  late final Isar _isar;

  DatabaseRepository() {
    // This constructor is intentionally left empty.
    // Initialization is handled by the static 'init' method.
  }

  static Future<DatabaseRepository> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [NoteSchema], // We need to tell Isar about our schema
      directory: dir.path,
    );

    final repo = DatabaseRepository();
    repo._isar = isar;
    return repo;
  }

  Future<List<Note>> getAllNotes() async {
    return await _isar.notes.where().sortByCreatedAtDesc().findAll();
  }

  Future<void> saveNote(Note note) async {
    await _isar.writeTxn(() async {
      await _isar.notes.put(note);
    });
  }

  /// Deletes a note from the database and its associated audio file from storage.
  Future<void> deleteNote(int id, String audioFilePath) async {
    // Delete the database record
    await _isar.writeTxn(() async {
      await _isar.notes.delete(id);
    });

    // Delete the audio file
    try {
      final file = File(audioFilePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Log or handle file deletion error if necessary
      print('Error deleting audio file: $e');
    }
  }

  // In a future sprint, we can add search functionality here.
}
