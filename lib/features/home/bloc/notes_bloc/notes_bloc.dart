import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fieldnote/core/models/note.dart';
import 'package:fieldnote/core/repositories/database_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final DatabaseRepository _databaseRepository;

  NotesBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(
    LoadNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoadInProgress());
    try {
      final notes = await _databaseRepository.getAllNotes();
      emit(NotesLoadSuccess(notes));
    } catch (e) {
      emit(const NotesLoadFailure('Failed to load notes.'));
    }
  }

  Future<void> _onAddNote(
    AddNote event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _databaseRepository.saveNote(event.note);
      // After adding, reload the notes to update the UI
      add(LoadNotes());
    } catch (e) {
      // Handle error if needed, maybe emit a specific failure state
    }
  }

  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _databaseRepository.deleteNote(event.id, event.audioFilePath);
      // After deleting, reload the notes to update the UI
      add(LoadNotes());
    } catch (e) {
      // Handle error
    }
  }
}
