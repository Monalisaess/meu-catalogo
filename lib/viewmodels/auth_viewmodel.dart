//controlo o estado das telas de login, cadastro e recuperação de senha

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _service;

  AuthViewModel({AuthService? service}) : _service = service ?? AuthService();

  bool _carregando = false;
  String? _erro;

  bool get carregando => _carregando;
  String? get erro => _erro;
  Stream<User?> get estadoAutenticacao => _service.estadoAutenticacao;
  User? get usuario => _service.usuarioAtual;

  void limparErro() {
    if (_erro == null) return;
    _erro = null;
    notifyListeners();
  }

  // cada método devolve true se deu certo; se falhar, guarda a mensagem em _erro
  Future<bool> entrar(String email, String senha) =>
      _executar(() => _service.entrar(email.trim(), senha));

  Future<bool> cadastrar(String nome, String email, String senha) =>
      _executar(() => _service.cadastrar(nome.trim(), email.trim(), senha));

  Future<bool> recuperarSenha(String email) =>
      _executar(() => _service.recuperarSenha(email.trim()));

  Future<void> sair() => _service.sair();

  Future<bool> _executar(Future<void> Function() acao) async {
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      await acao();
      return true;
    } on FirebaseAuthException catch (e) {
      _erro = _traduzirErro(e.code);
      return false;
    } catch (_) {
      _erro = 'Algo deu errado. Tente novamente.';
      return false;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  String _traduzirErro(String codigo) {
    switch (codigo) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'email-already-in-use':
        return 'Já existe uma conta com este e-mail.';
      case 'weak-password':
        return 'Senha fraca. Use pelo menos 6 caracteres.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um pouco e tente de novo.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      case 'operation-not-allowed':
        return 'Login por e-mail/senha não está ativado no Firebase.';
      default:
        return 'Erro de autenticação ($codigo).';
    }
  }
}
