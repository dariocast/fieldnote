part of 'recording_bloc.dart';

abstract class RecordingEvent extends Equatable {
  const RecordingEvent();

  @override
  List<Object> get props => [];
}

class CheckPermissions extends RecordingEvent {}

/// Event to start a new recording.
class StartRecording extends RecordingEvent {}

/// Event to stop the current recording.
class StopRecording extends RecordingEvent {}
