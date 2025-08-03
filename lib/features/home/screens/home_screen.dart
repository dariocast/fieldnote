import 'package:fieldnote/core/models/note.dart';
import 'package:fieldnote/features/home/bloc/notes_bloc/notes_bloc.dart';
import 'package:fieldnote/features/home/bloc/recording_bloc/recording_bloc.dart';
import 'package:fieldnote/features/home/widgets/note_list_item.dart'; // Import the new widget
import 'package:fieldnote/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RecordingBloc>().add(InitializeRecording());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Notes',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state is NotesLoadSuccess) {
                  if (state.notes.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return NoteListItem(note: note);
                    },
                  );
                }
                if (state is NotesLoadFailure) {
                  return Center(child: Text(state.errorMessage));
                }
                // Default to a loading indicator for Initial/InProgress states
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _buildInteractionArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.note_add_outlined,
              size: 64,
              color: AppColors.textGray,
            ),
            const SizedBox(height: 16),
            Text(
              'Your recorded notes will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the button below to capture your first thought.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionArea() {
    // ... This function remains unchanged from the previous task
    return BlocListener<RecordingBloc, RecordingState>(
      listener: (context, state) {
        if (state is RecordingSuccess) {
          final newNote = Note()
            ..audioFilePath = state.result.filePath
            ..transcription = state.result.transcription
            ..createdAt = DateTime.now()
            ..durationInSeconds = 0;

          context.read<NotesBloc>().add(AddNote(newNote));

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Recording transcribed and saved!'),
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

class _RecordButton extends StatelessWidget {
  // ... This widget remains unchanged from the previous task
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
