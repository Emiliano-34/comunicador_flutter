// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/login_screen.dart';
import '/register_screen.dart';
import '/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App Educativa',
      theme: ThemeData(primarySwatch: Colors.purple),

      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/login'
          : '/home',

      routes: {
        '/login': (ctx) => const LoginScreen(),
        '/register': (ctx) => const RegisterScreen(),
        '/home': (ctx) => const HomeScreen(),
      },

      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}