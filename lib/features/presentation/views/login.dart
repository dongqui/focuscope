import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// 간단한 로그인 화면 (구글 로그인만 예시)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn signIn = GoogleSignIn.instance;

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final signIn = GoogleSignIn.instance;
      if (signIn.supportsAuthenticate()) {
        await signIn.authenticate();
        final user = signIn;
        final idToken = await user.authorizationClient.;
        final accessToken = await user.authorizationClient.accessToken;

        // Firebase Auth 연동
        if (idToken != null) {
          final credential = GoogleAuthProvider.credential(
            idToken: idToken,
            accessToken: accessToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('구글 로그인 실패: $e')),
      );
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint('애플 로그인 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('애플 로그인 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('로그인이 필요합니다'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _signInWithGoogle(context),
              child: const Text('구글로 로그인'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _signInWithApple(context),
              child: const Text('Apple로 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}

// 인증 상태에 따라 로그인 또는 메인 홈을 보여주는 위젯
class AuthGate extends StatelessWidget {
  final Widget child;
  const AuthGate({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return child;
        }
        return LoginScreen();
      },
    );
  }
}

Future<bool> ensureLoggedIn(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) return true;

  // 로그인 화면으로 이동 (로그인 성공 시 true 반환)
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => LoginScreen()),
  );
  return result == true;
}
