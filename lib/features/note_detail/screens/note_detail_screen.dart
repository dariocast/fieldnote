import 'package:fieldnote/core/models/note.dart';
import 'package:fieldnote/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The default back button is used, which is good for platform consistency.
        title: Text(
          DateFormat.yMMMd().format(note.createdAt),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.delete_outline, color: AppColors.primaryBlue),
            onPressed: () {
              // TODO: Implement delete functionality in Task 3
            },
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
          // Placeholder for the audio player UI
          _buildAudioPlayerArea(),
        ],
      ),
    );
  }

  Widget _buildAudioPlayerArea() {
    // This will be implemented in Task 2
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_circle_fill,
              size: 48, color: AppColors.lightGrayFill),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Audio Player Coming Soon',
              style: TextStyle(color: AppColors.textGray),
            ),
          ),
        ],
      ),
    );
  }
}
