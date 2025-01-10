import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (auth.error != null) {
            return Center(child: Text(auth.error!));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<AuthProvider>().signInWithGoogle(),
                  child: const Text('Google로 로그인'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<AuthProvider>().signInWithApple(),
                  child: const Text('Apple로 로그인'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
