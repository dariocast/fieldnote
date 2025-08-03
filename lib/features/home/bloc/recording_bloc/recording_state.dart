part of 'recording_bloc.dart';

abstract class RecordingState extends Equatable {
  const RecordingState();

  @override
  List<Object> get props => [];
}

/// The initial state before any permission check has been made.
class PermissionInitial extends RecordingState {}

/// State indicating that all required permissions have been granted.
class PermissionGranted extends RecordingState {}

/// State indicating that one or more required permissions were denied.
class PermissionFailure extends RecordingState {
  final String errorMessage;

  const PermissionFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

/// TODO: Add RecordingInProgress and RecordingSuccess states.
