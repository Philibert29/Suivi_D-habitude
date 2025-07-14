import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  bool isLogin = true;
  String? errorMessage;

  void handleSubmit() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      if (isLogin) {
        await authService.signIn(email, password);
      } else {
        await authService.signUp(email, password);
      }

      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Connexion' : 'Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (errorMessage != null) ...[
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
            ],
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: handleSubmit,
              child: Text(isLogin ? 'Se connecter' : 'S’inscrire'),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? 'Créer un compte' : 'Déjà inscrit ? Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
