import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        super(PermissionInitial()) {
    on<CheckPermissions>(_onCheckPermissions);
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
  }

  Future<void> _onCheckPermissions(
    CheckPermissions event,
    Emitter<RecordingState> emit,
  ) async {
    // ... (code from previous task, unchanged)
    try {
      final bool hasPermissions =
          await _permissionsRepository.requestRequiredPermissions();
      if (hasPermissions) {
        emit(PermissionGranted());
      } else {
        emit(const PermissionFailure(
            'Microphone and speech recognition permissions are required to use this app. Please grant them in your device settings.'));
      }
    } catch (e) {
      emit(const PermissionFailure(
          'An unexpected error occurred while checking permissions.'));
    }
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      await _recordingRepository.startRecording();
      emit(RecordingInProgress());
    } catch (e) {
      emit(const RecordingFailure('Failed to start recording.'));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<RecordingState> emit,
  ) async {
    try {
      final String? path = await _recordingRepository.stopRecording();
      if (path != null) {
        emit(RecordingSuccess(path));
        // After success, transition back to the ready state
        emit(PermissionGranted());
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
