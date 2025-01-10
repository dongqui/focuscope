import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:catodo/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:catodo/features/auth/presentation/pages/login_page.dart';
import 'firebase_options.dart';
import 'package:catodo/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:catodo/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:catodo/features/auth/presentation/providers/auth_provider.dart'
    as app_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final authRepository = FirebaseAuthRepository(firebaseAuth, googleSignIn);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => app_provider.AuthProvider(
            SignInWithGoogle(authRepository),
            SignInWithApple(authRepository),
            authRepository,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catodo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
