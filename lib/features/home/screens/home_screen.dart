import 'package:fieldnote/features/home/bloc/recording_bloc/recording_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RecordingBloc>().add(CheckPermissions());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
      ),
      body: BlocListener<RecordingBloc, RecordingState>(
        listener: (context, state) {
          if (state is RecordingSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Recording saved!')),
              );
          } else if (state is RecordingFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text('Error: ${state.errorMessage}'),
                    backgroundColor: Colors.red),
              );
          }
        },
        child: Center(
          child: BlocBuilder<RecordingBloc, RecordingState>(
            builder: (context, state) {
              if (state is PermissionInitial) {
                return const CircularProgressIndicator();
              }
              if (state is PermissionFailure) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(state.errorMessage, textAlign: TextAlign.center),
                );
              }
              if (state is RecordingInProgress) {
                return _buildRecordingUI(context);
              }
              // Default state: PermissionGranted or after a recording is finished.
              return _buildIdleUI(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIdleUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Tap to start recording'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.read<RecordingBloc>().add(StartRecording()),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
          ),
          child: const Icon(Icons.mic, size: 48),
        ),
      ],
    );
  }

  Widget _buildRecordingUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Recording...', style: TextStyle(color: Colors.red)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.read<RecordingBloc>().add(StopRecording()),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
            backgroundColor: Colors.red,
          ),
          child: const Icon(Icons.stop, size: 48),
        ),
      ],
    );
  }
}
