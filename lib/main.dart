import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/screens/login_screen.dart';
import 'package:provider/provider.dart' as p;
import 'package:stray_animals_ui/screens/nearest_pet_store.dart';

import 'blocs/application_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return p.ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LoginScreen(),
      ),
    );
  }
}
