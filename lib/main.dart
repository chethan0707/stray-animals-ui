import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stray_animals_ui/screens/login_screen.dart';
import 'package:provider/provider.dart' as p;
import 'package:stray_animals_ui/themes.dart';

import 'blocs/application_bloc.dart';
import 'blocs/local_storage.dart';
import 'blocs/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String currentTheme = await LocalStorage.getTheme() ?? "light";
  runApp(
    ProviderScope(
      child: MyApp(
        theme: currentTheme,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String theme;
  const MyApp({super.key, required this.theme});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return p.MultiProvider(
      providers: [
        p.ChangeNotifierProvider(
          create: (context) => ThemeProvider(widget.theme),
        ),
        p.ChangeNotifierProvider(
          create: (context) => ApplicationBloc(),
        ),
      ],
      child: p.Consumer<ThemeProvider>(
        builder: (context, themeData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            // home: UserReportScreen(
            //     userEmail: "s@gmail.com", ngoEmail: "koderktngo@gmail.com"),
            home: const LoginScreen(),
            themeMode: themeData.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
          );
        },
      ),
    );
  }
}
