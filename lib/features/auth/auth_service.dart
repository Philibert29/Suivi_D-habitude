import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<void> signUp(String email, String password) async {
    final response = await _client.auth.signUp(email: email, password: password);
    if (response.user == null) throw Exception('Erreur lors de l’inscription');
  }

  Future<void> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(email: email, password: password);
    if (response.user == null) throw Exception('Erreur lors de la connexion');
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
}
