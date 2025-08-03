part of 'recording_bloc.dart';

abstract class RecordingEvent extends Equatable {
  const RecordingEvent();

  @override
  List<Object> get props => [];
}

/// Event to trigger the permission check.
class CheckPermissions extends RecordingEvent {}

/// TODO: Add StartRecording and StopRecording events in the next task.
