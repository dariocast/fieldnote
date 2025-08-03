import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fieldnote/core/repositories/audio_player_repository.dart';
import 'package:just_audio/just_audio.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayerRepository _audioPlayerRepository;
  StreamSubscription? _playerStateSubscription;

  Stream<Duration> get positionStream => _audioPlayerRepository.positionStream;

  AudioPlayerBloc({required AudioPlayerRepository audioPlayerRepository})
      : _audioPlayerRepository = audioPlayerRepository,
        super(AudioPlayerInitial()) {
    on<LoadAudio>(_onLoadAudio);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<SeekAudio>(_onSeekAudio);
    on<_UpdatePlayerState>(_onUpdatePlayerState);

    _playerStateSubscription =
        _audioPlayerRepository.playerStateStream.listen((state) {
      add(_UpdatePlayerState(state));
    });
  }

  Future<void> _onLoadAudio(
      LoadAudio event, Emitter<AudioPlayerState> emit) async {
    emit(AudioPlayerLoadInProgress());
    try {
      await _audioPlayerRepository.loadAudio(event.filePath);
    } catch (e) {
      emit(const AudioPlayerFailure('Failed to load audio file.'));
    }
  }

  void _onUpdatePlayerState(
      _UpdatePlayerState event, Emitter<AudioPlayerState> emit) {
    final playerState = event.playerState;
    final duration = _audioPlayerRepository.duration ?? Duration.zero;
    final position = _audioPlayerRepository.position;

    if (playerState.playing) {
      emit(AudioPlayerPlaying(duration, position));
    } else {
      if (playerState.processingState == ProcessingState.completed) {
        _audioPlayerRepository.seek(Duration.zero);
        emit(AudioPlayerPaused(duration, Duration.zero));
      } else {
        emit(AudioPlayerPaused(duration, position));
      }
    }
  }

  Future<void> _onPlayAudio(
      PlayAudio event, Emitter<AudioPlayerState> emit) async {
    await _audioPlayerRepository.play();
  }

  Future<void> _onPauseAudio(
      PauseAudio event, Emitter<AudioPlayerState> emit) async {
    await _audioPlayerRepository.pause();
  }

  Future<void> _onSeekAudio(
      SeekAudio event, Emitter<AudioPlayerState> emit) async {
    await _audioPlayerRepository.seek(event.position);
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _audioPlayerRepository.dispose();
    return super.close();
  }
}
