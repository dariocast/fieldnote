import 'package:fieldnote/core/repositories/database_repository.dart';
import 'package:fieldnote/core/repositories/permissions_repository.dart';
import 'package:fieldnote/core/repositories/recording_repository.dart';
import 'package:fieldnote/features/home/bloc/notes_bloc/notes_bloc.dart';
import 'package:fieldnote/features/home/bloc/recording_bloc/recording_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fieldnote/features/home/screens/home_screen.dart';
import 'package:fieldnote/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database repository
  final databaseRepository = await DatabaseRepository.init();

  runApp(FieldNoteApp(databaseRepository: databaseRepository));
}

class FieldNoteApp extends StatelessWidget {
  final DatabaseRepository databaseRepository;

  const FieldNoteApp({
    super.key,
    required this.databaseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: databaseRepository),
        RepositoryProvider<PermissionsRepository>(
          create: (context) => PermissionsRepository(),
        ),
        RepositoryProvider<RecordingRepository>(
          create: (context) => RecordingRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RecordingBloc>(
            create: (context) => RecordingBloc(
              permissionsRepository: context.read<PermissionsRepository>(),
              recordingRepository: context.read<RecordingRepository>(),
            ),
          ),
          BlocProvider<NotesBloc>(
            create: (context) => NotesBloc(
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(LoadNotes()), // Load notes when the app starts
          ),
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
