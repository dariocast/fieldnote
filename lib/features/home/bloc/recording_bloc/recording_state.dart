part of 'recording_bloc.dart';

abstract class RecordingState extends Equatable {
  const RecordingState();
  @override
  List<Object> get props => [];
}

class RecordingInitial extends RecordingState {}

// Renamed from PermissionGranted
class RecordingReady extends RecordingState {}

// Renamed from PermissionFailure
class RecordingPermissionFailure extends RecordingState {
  final String errorMessage;
  const RecordingPermissionFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class RecordingInProgress extends RecordingState {}

class RecordingSuccess extends RecordingState {
  final RecordingResult result;
  const RecordingSuccess(this.result);
  @override
  List<Object> get props => [result];
}

class RecordingFailure extends RecordingState {
  final String errorMessage;
  const RecordingFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
