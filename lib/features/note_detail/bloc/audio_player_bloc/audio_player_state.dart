part of 'audio_player_bloc.dart';

abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();
  @override
  List<Object> get props => [];
}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerLoadInProgress extends AudioPlayerState {}

class AudioPlayerReady extends AudioPlayerState {
  final Duration duration;
  const AudioPlayerReady(this.duration);
  @override
  List<Object> get props => [duration];
}

class AudioPlayerPlaying extends AudioPlayerState {
  final Duration duration;
  final Duration position;
  const AudioPlayerPlaying(this.duration, this.position);
  @override
  List<Object> get props => [duration, position];
}

class AudioPlayerPaused extends AudioPlayerState {
  final Duration duration;
  final Duration position;
  const AudioPlayerPaused(this.duration, this.position);
  @override
  List<Object> get props => [duration, position];
}

class AudioPlayerFailure extends AudioPlayerState {
  final String message;
  const AudioPlayerFailure(this.message);
  @override
  List<Object> get props => [message];
}
