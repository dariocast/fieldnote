part of 'recording_bloc.dart';

sealed class RecordingState extends Equatable {
  const RecordingState();
  
  @override
  List<Object> get props => [];
}

final class RecordingInitial extends RecordingState {}
