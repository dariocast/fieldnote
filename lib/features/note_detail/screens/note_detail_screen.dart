import 'package:fieldnote/core/models/note.dart';
import 'package:fieldnote/core/repositories/audio_player_repository.dart';
import 'package:fieldnote/features/home/bloc/notes_bloc/notes_bloc.dart';
import 'package:fieldnote/features/note_detail/bloc/audio_player_bloc/audio_player_bloc.dart';
import 'package:fieldnote/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioPlayerBloc(
        audioPlayerRepository: AudioPlayerRepository(),
      )..add(LoadAudio(note.audioFilePath)),
      child: _NoteDetailView(note: note),
    );
  }
}

class _NoteDetailView extends StatelessWidget {
  final Note note;
  const _NoteDetailView({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMd().format(note.createdAt),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppColors.destructiveRed),
            onPressed: () => _showDeleteConfirmationDialog(context, note),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                note.transcription.isEmpty
                    ? 'This note has no transcription.'
                    : note.transcription,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18, height: 1.5),
              ),
            ),
          ),
          _AudioPlayerWidget(),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Note note) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Note?'),
          content: const Text(
              'Are you sure you want to permanently delete this note? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.destructiveRed)),
              onPressed: () {
                // Dispatch the delete event
                context.read<NotesBloc>().add(
                      DeleteNote(
                          id: note.id, audioFilePath: note.audioFilePath),
                    );
                // Pop the dialog
                Navigator.of(dialogContext).pop();
                // Pop the detail screen to return to the home screen
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _AudioPlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
        builder: (context, state) {
          if (state is AudioPlayerPlaying || state is AudioPlayerPaused) {
            final duration = state is AudioPlayerPlaying
                ? state.duration
                : (state as AudioPlayerPaused).duration;
            final bool isPlaying = state is AudioPlayerPlaying;

            return Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 48,
                    color: AppColors.accentBlue,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      context.read<AudioPlayerBloc>().add(PauseAudio());
                    } else {
                      context.read<AudioPlayerBloc>().add(PlayAudio());
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      StreamBuilder<Duration>(
                          stream:
                              context.read<AudioPlayerBloc>().positionStream,
                          builder: (context, snapshot) {
                            final currentPosition =
                                snapshot.data ?? Duration.zero;
                            return Slider(
                              value: currentPosition.inMilliseconds
                                  .toDouble()
                                  .clamp(
                                      0.0, duration.inMilliseconds.toDouble()),
                              max: duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                context.read<AudioPlayerBloc>().add(SeekAudio(
                                    Duration(milliseconds: value.toInt())));
                              },
                              activeColor: AppColors.accentBlue,
                              inactiveColor: AppColors.lightGrayFill,
                            );
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<Duration>(
                              stream: context
                                  .read<AudioPlayerBloc>()
                                  .positionStream,
                              builder: (context, snapshot) {
                                final currentPosition =
                                    snapshot.data ?? Duration.zero;
                                return Text(_formatDuration(currentPosition),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium);
                              }),
                          Text(_formatDuration(duration),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
