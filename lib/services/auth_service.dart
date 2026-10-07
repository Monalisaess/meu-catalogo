//camada que conversa direto com o Firebase Authentication

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // emite um evento sempre que o usuário entra ou sai
  Stream<User?> get estadoAutenticacao => _auth.authStateChanges();

  User? get usuarioAtual => _auth.currentUser;

  Future<void> entrar(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> cadastrar(String nome, String email, String senha) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    await credencial.user?.updateDisplayName(nome);
  }

  Future<void> recuperarSenha(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sair() => _auth.signOut();
}
