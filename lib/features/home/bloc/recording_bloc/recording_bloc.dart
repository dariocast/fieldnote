import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fieldnote/core/repositories/permissions_repository.dart';
import 'package:fieldnote/core/repositories/recording_repository.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final PermissionsRepository _permissionsRepository;
  final RecordingRepository _recordingRepository;

  RecordingBloc({
    required PermissionsRepository permissionsRepository,
    required RecordingRepository recordingRepository,
  })  : _permissionsRepository = permissionsRepository,
        _recordingRepository = recordingRepository,
        super(RecordingInitial()) {
    on<InitializeRecording>(_onInitializeRecording);
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
  }

  Future<void> _onInitializeRecording(
    InitializeRecording event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      final bool hasPermissions =
          await _permissionsRepository.requestRequiredPermissions();
      if (!hasPermissions) {
        emit(const RecordingPermissionFailure(
            'Microphone and speech recognition permissions are required.'));
        return;
      }
      final bool isInitialized = await _recordingRepository.initialize();
      if (isInitialized) {
        emit(RecordingReady());
      } else {
        emit(const RecordingFailure('Failed to initialize speech recognizer.'));
      }
    } catch (e) {
      emit(const RecordingFailure(
          'An unexpected error occurred during initialization.'));
    }
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      // Check the result of startRecording
      final bool didStart = await _recordingRepository.startRecording();
      if (didStart) {
        emit(RecordingInProgress());
      } else {
        // If it failed to start, emit a failure state immediately.
        emit(const RecordingFailure(
            'Failed to start recording. Please try again.'));
        // Go back to the ready state so the user can try again.
        emit(RecordingReady());
      }
    } catch (e) {
      emit(const RecordingFailure('Failed to start recording.'));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      final RecordingResult? result =
          await _recordingRepository.stopRecording();
      if (result != null) {
        emit(RecordingSuccess(result));
        emit(RecordingReady()); // Transition back to ready state
      } else {
        emit(const RecordingFailure('No recording was in progress.'));
      }
    } catch (e) {
      emit(const RecordingFailure('Failed to stop recording.'));
    }
  }

  @override
  Future<void> close() {
    _recordingRepository.dispose();
    return super.close();
  }
}
