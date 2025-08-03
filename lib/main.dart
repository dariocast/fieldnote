import 'package:flutter/material.dart';
import 'package:fieldnote/features/home/screens/home_screen.dart'; // Path follows our architecture
import 'package:fieldnote/shared/theme/app_theme.dart'; // Path follows our architecture

void main() async {
  // Required for Isar and other async services before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize Isar Database
  // TODO: Initialize Blocs and Repositories

  runApp(const FieldNoteApp());
}

class FieldNoteApp extends StatelessWidget {
  const FieldNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Wrap with BlocProvider for dependency injection
    return MaterialApp(
      title: 'FieldNote',
      theme: AppTheme.lightTheme, // Using a custom theme object
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
