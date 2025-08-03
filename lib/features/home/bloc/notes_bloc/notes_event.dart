part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final Note note;
  const AddNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final int id;
  final String audioFilePath; // Add this property

  const DeleteNote({required this.id, required this.audioFilePath});

  @override
  List<Object> get props => [id, audioFilePath];
}
