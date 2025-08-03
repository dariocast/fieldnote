import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  RecordingBloc() : super(RecordingInitial()) {
    on<RecordingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
