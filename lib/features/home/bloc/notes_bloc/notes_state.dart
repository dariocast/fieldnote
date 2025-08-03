part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoadInProgress extends NotesState {}

class NotesLoadSuccess extends NotesState {
  final List<Note> notes;
  const NotesLoadSuccess(this.notes);

  @override
  List<Object> get props => [notes];
}

class NotesLoadFailure extends NotesState {
  final String errorMessage;
  const NotesLoadFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
