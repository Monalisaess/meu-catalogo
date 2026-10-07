//tela de recuperação de senha: envia o e-mail de redefinição do Firebase

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets_auth.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _enviado = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    final ok =
        await context.read<AuthViewModel>().recuperarSenha(_emailController.text);
    if (ok && mounted) setState(() => _enviado = true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return AuthScaffold(
      titulo: 'Recuperar senha',
      subtitulo: 'Enviaremos um link para você redefinir sua senha',
      mostrarVoltar: true,
      child: _enviado
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.mark_email_read_outlined,
                    size: 48, color: corPrincipal),
                const SizedBox(height: 12),
                Text(
                  'Se existir uma conta com ${_emailController.text.trim()}, '
                  'você receberá o e-mail em instantes. Confira também o spam.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                BotaoPrincipal(
                  texto: 'Voltar ao login',
                  carregando: false,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _enviar(),
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: validarEmail,
                  ),
                  const SizedBox(height: 16),
                  MensagemErro(vm.erro),
                  BotaoPrincipal(
                    texto: 'Enviar link',
                    carregando: vm.carregando,
                    onPressed: _enviar,
                  ),
                ],
              ),
            ),
    );
  }
}
