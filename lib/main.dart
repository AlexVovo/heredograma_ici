import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'views/main_navigation.dart';
import 'views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _initialization;

  Future<void> _initializeApp({bool showSplashDelay = true}) async {
    await Future.wait([
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      if (showSplashDelay)
        Future<void>.delayed(const Duration(milliseconds: 1400)),
    ]);
  }

  @override
  void initState() {
    super.initState();
    // Mantém a marca visível por tempo suficiente para uma transição suave.
    _initialization = _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeredoConco',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SplashScreen();
          }

          if (snapshot.hasError) {
            return InitializationErrorScreen(
              onRetry: () => setState(() {
                _initialization = _initializeApp(showSplashDelay: false);
              }),
            );
          }

          return const MainNavigation();
        },
      ),
    );
  }
}
