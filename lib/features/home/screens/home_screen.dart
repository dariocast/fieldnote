import 'package:fieldnote/core/models/note.dart'; // Import Note model
import 'package:fieldnote/features/home/bloc/notes_bloc/notes_bloc.dart'; // Import NotesBloc
import 'package:fieldnote/features/home/bloc/recording_bloc/recording_bloc.dart';
import 'package:fieldnote/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check permissions when the screen is first built
    context.read<RecordingBloc>().add(InitializeRecording());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TODO: Replace with the actual note list in Sprint 2
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Your recorded notes will appear here. Tap the button below to capture your first thought.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            _buildInteractionArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionArea() {
    return BlocListener<RecordingBloc, RecordingState>(
      listener: (context, state) {
        if (state is RecordingSuccess) {
          // Create a new Note object
          final newNote = Note()
            ..audioFilePath = state.result.filePath
            ..transcription =
                state.result.transcription // Use the transcription
            ..createdAt = DateTime.now()
            ..durationInSeconds = 0; // TODO: Calculate actual duration

          // Add the new note to the database via the NotesBloc
          context.read<NotesBloc>().add(AddNote(newNote));

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Recording saved!'),
                backgroundColor: AppColors.calmGreen,
              ),
            );
        } else if (state is RecordingFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errorMessage}'),
                backgroundColor: AppColors.destructiveRed,
              ),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, top: 16.0),
        child: BlocBuilder<RecordingBloc, RecordingState>(
          builder: (context, state) {
            if (state is RecordingInitial) {
              return const CircularProgressIndicator();
            }
            if (state is RecordingPermissionFailure ||
                state is RecordingFailure) {
              final String message = state is RecordingPermissionFailure
                  ? state.errorMessage
                  : (state as RecordingFailure).errorMessage;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.destructiveRed),
                ),
              );
            }
            if (state is RecordingInProgress) {
              return _RecordButton(
                isRecording: true,
                onTap: () => context.read<RecordingBloc>().add(StopRecording()),
              );
            }
            // Default state: RecordingReady or after a recording is finished.
            return _RecordButton(
              isRecording: false,
              onTap: () => context.read<RecordingBloc>().add(StartRecording()),
            );
          },
        ),
      ),
    );
  }
}

/// A custom circular record button widget based on the design system.
class _RecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTap;

  const _RecordButton({required this.isRecording, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: isRecording ? AppColors.destructiveRed : AppColors.accentBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          isRecording ? Icons.stop_rounded : Icons.mic_none_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
