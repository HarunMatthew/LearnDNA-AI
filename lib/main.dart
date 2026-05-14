import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCaxIr7O2L-12jGyxhhkLokD8Vvvza0XcU",
        authDomain: "learndna-ai1.firebaseapp.com",
        projectId: "learndna-ai1",
        storageBucket: "learndna-ai1.firebasestorage.app",
        messagingSenderId: "760505590984",
        appId: "1:760505590984:web:f03e3891d5708052ba71fd",
      ),
    );
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const LearnDNAApp(),
    ),
  );
}

class LearnDNAApp extends StatelessWidget {
  const LearnDNAApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LearnDNA AI',
      themeMode:
          themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),

      home: const LoginScreen(),
    );
  }
}