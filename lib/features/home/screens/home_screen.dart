import 'package:fieldnote/features/home/bloc/recording_bloc/recording_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the permission check when the screen is built
    context.read<RecordingBloc>().add(CheckPermissions());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
      ),
      body: Center(
        child: BlocBuilder<RecordingBloc, RecordingState>(
          builder: (context, state) {
            if (state is PermissionInitial) {
              return const CircularProgressIndicator();
            }
            if (state is PermissionGranted) {
              // This is where the main UI with the record button will go.
              return const Text('Permissions Granted! Ready to record.');
            }
            if (state is PermissionFailure) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.red),
                ),
              );
            }
            // Fallback for any other states
            return const Text('Something went wrong.');
          },
        ),
      ),
    );
  }
}
