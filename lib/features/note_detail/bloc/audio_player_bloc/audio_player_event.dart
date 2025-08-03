part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();
  @override
  List<Object> get props => [];
}

class LoadAudio extends AudioPlayerEvent {
  final String filePath;
  const LoadAudio(this.filePath);
  @override
  List<Object> get props => [filePath];
}

class PlayAudio extends AudioPlayerEvent {}

class PauseAudio extends AudioPlayerEvent {}

class SeekAudio extends AudioPlayerEvent {
  final Duration position;
  const SeekAudio(this.position);
  @override
  List<Object> get props => [position];
}

class _UpdatePlayerState extends AudioPlayerEvent {
  final PlayerState playerState;
  const _UpdatePlayerState(this.playerState);
  @override
  List<Object> get props => [playerState];
}
