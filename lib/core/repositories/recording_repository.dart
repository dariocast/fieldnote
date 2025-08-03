import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordingRepository {
  final AudioRecorder _audioRecorder;

  RecordingRepository({AudioRecorder? audioRecorder})
      : _audioRecorder = audioRecorder ?? AudioRecorder();

  /// Starts a new audio recording.
  Future<void> startRecording() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String filePath = p.join(
      appDocumentsDir.path,
      'recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    // Using the .m4a encoder for good quality and compatibility
    const config = RecordConfig(encoder: AudioEncoder.aacLc);

    await _audioRecorder.start(config, path: filePath);
  }

  /// Stops the current recording and returns the path to the saved file.
  /// Returns null if no recording was in progress.
  Future<String?> stopRecording() async {
    if (await _audioRecorder.isRecording()) {
      final String? path = await _audioRecorder.stop();
      return path;
    }
    return null;
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}
