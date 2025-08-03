part of 'recording_bloc.dart';

abstract class RecordingState extends Equatable {
  const RecordingState();

  @override
  List<Object> get props => [];
}

class PermissionInitial extends RecordingState {}

class PermissionGranted extends RecordingState {}

class PermissionFailure extends RecordingState {
  final String errorMessage;
  const PermissionFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

/// State indicating a recording is currently in progress.
class RecordingInProgress extends RecordingState {}

/// State indicating a recording has successfully completed and was saved.
class RecordingSuccess extends RecordingState {
  final String filePath;
  const RecordingSuccess(this.filePath);
  @override
  List<Object> get props => [filePath];
}

/// State indicating an error occurred during recording.
class RecordingFailure extends RecordingState {
  final String errorMessage;
  const RecordingFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
