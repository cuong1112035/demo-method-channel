import 'package:app/core/bloc_provider.dart';
import 'package:app/features/demo_bloc.dart';
import 'package:app/features/demo_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => DemoBloc(),
        child: const DemoScreen(),
      ),
    );
  }
}


