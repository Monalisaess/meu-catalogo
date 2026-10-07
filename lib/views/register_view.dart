//tela de cadastro (nome, e-mail, senha e confirmação)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<AuthViewModel>();
    final navigator = Navigator.of(context);

    final ok = await vm.cadastrar(
      _nomeController.text,
      _emailController.text,
      _senhaController.text,
    );

    // o Firebase já deixa o usuário logado após cadastrar;
    // volto à raiz para o AuthGate mostrar o catálogo
    if (ok && mounted) navigator.popUntil((rota) => rota.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return AuthScaffold(
      titulo: 'Criar conta',
      mostrarVoltar: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nome',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: validarEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _senhaController,
              obscureText: _ocultarSenha,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_ocultarSenha
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () =>
                      setState(() => _ocultarSenha = !_ocultarSenha),
                ),
              ),
              validator: (v) => (v == null || v.length < 6)
                  ? 'A senha deve ter pelo menos 6 caracteres'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmarController,
              obscureText: _ocultarSenha,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _cadastrar(),
              decoration: const InputDecoration(
                labelText: 'Confirmar senha',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v != _senhaController.text ? 'As senhas não coincidem' : null,
            ),
            const SizedBox(height: 16),
            MensagemErro(vm.erro),
            BotaoPrincipal(
              texto: 'Cadastrar',
              carregando: vm.carregando,
              onPressed: _cadastrar,
            ),
          ],
        ),
      ),
    );
  }
}
