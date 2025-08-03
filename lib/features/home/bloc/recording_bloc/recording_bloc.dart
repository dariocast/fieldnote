import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fieldnote/core/repositories/permissions_repository.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final PermissionsRepository _permissionsRepository;

  RecordingBloc({required PermissionsRepository permissionsRepository})
      : _permissionsRepository = permissionsRepository,
        super(PermissionInitial()) {
    on<CheckPermissions>(_onCheckPermissions);
  }

  Future<void> _onCheckPermissions(
    CheckPermissions event,
    Emitter<RecordingState> emit,
  ) async {
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
}
