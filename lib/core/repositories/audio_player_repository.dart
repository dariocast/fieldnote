import 'package:just_audio/just_audio.dart';

class AudioPlayerRepository {
  final AudioPlayer _audioPlayer;

  AudioPlayerRepository({AudioPlayer? audioPlayer})
      : _audioPlayer = audioPlayer ?? AudioPlayer();

  Duration? get duration => _audioPlayer.duration;
  Duration get position => _audioPlayer.position;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Future<void> loadAudio(String filePath) async {
    try {
      await _audioPlayer.setFilePath(filePath);
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
