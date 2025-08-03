part of 'recording_bloc.dart';

abstract class RecordingEvent extends Equatable {
  const RecordingEvent();
  @override
  List<Object> get props => [];
}

// Renamed from CheckPermissions for clarity
class InitializeRecording extends RecordingEvent {}

class StartRecording extends RecordingEvent {}

class StopRecording extends RecordingEvent {}
