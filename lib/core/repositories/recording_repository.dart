import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// A custom result class to hold the output from the repository.
class RecordingResult {
  final String filePath;
  final String transcription;
  RecordingResult({required this.filePath, required this.transcription});
}

class RecordingRepository {
  final AudioRecorder _audioRecorder;
  final SpeechToText _speechToText;
  String _transcription = '';
  // A completer to signal when the final transcription result is received.
  Completer<String> _transcriptionCompleter = Completer<String>();

  RecordingRepository({
    AudioRecorder? audioRecorder,
    SpeechToText? speechToText,
  })  : _audioRecorder = audioRecorder ?? AudioRecorder(),
        _speechToText = speechToText ?? SpeechToText();

  /// Initializes the speech recognizer. Must be called before starting.
  Future<bool> initialize() async {
    return await _speechToText.initialize();
  }

  /// Starts both audio recording to a file and live transcription.
  Future<void> startRecording() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String filePath = p.join(
      appDocumentsDir.path,
      'recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
    const config = RecordConfig(encoder: AudioEncoder.aacLc);

    // Reset transcription state
    _transcription = '';
    _transcriptionCompleter = Completer<String>();

    // Start listening for speech
    _speechToText.listen(
      onResult: (result) {
        _transcription = result.recognizedWords;
        if (result.finalResult) {
          _transcriptionCompleter.complete(_transcription);
        }
      },
    );

    // Start recording to file
    await _audioRecorder.start(config, path: filePath);
  }

  /// Stops both recording and transcription, and returns the combined result.
  Future<RecordingResult?> stopRecording() async {
    if (await _audioRecorder.isRecording()) {
      final String? path = await _audioRecorder.stop();
      await _speechToText.stop();

      // Wait for the final transcription result
      final String finalTranscription = await _transcriptionCompleter.future;

      if (path != null) {
        return RecordingResult(
          filePath: path,
          transcription: finalTranscription,
        );
      }
    }
    return null;
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}
