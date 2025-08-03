import 'package:fieldnote/core/repositories/permissions_repository.dart';
import 'package:fieldnote/features/home/bloc/recording_bloc/recording_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fieldnote/features/home/screens/home_screen.dart';
import 'package:fieldnote/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize Isar Database
  // TODO: Initialize other Repositories

  runApp(const FieldNoteApp());
}

class FieldNoteApp extends StatelessWidget {
  const FieldNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide repositories and Blocs to the entire app.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PermissionsRepository>(
          create: (context) => PermissionsRepository(),
        ),
        // TODO: Add DatabaseRepository and RecordingRepository here
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RecordingBloc>(
            create: (context) => RecordingBloc(
              permissionsRepository: context.read<PermissionsRepository>(),
            ),
          ),
          // TODO: Add NotesBloc here
        ],
        child: MaterialApp(
          title: 'FieldNote',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
