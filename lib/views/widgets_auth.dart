//componentes visuais reaproveitados pelas telas de autenticação

import 'package:flutter/material.dart';

const corPrincipal = Color(0xFFE75480);

class AuthScaffold extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final Widget child;
  final bool mostrarVoltar;

  const AuthScaffold({
    super.key,
    required this.titulo,
    required this.child,
    this.subtitulo,
    this.mostrarVoltar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mostrarVoltar
          ? AppBar(backgroundColor: Colors.transparent, elevation: 0)
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.face_retouching_natural,
                      size: 64, color: corPrincipal),
                  const SizedBox(height: 12),
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (subtitulo != null) ...[
                    const SizedBox(height: 8),
                    Text(subtitulo!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700])),
                  ],
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MensagemErro extends StatelessWidget {
  final String? mensagem;
  const MensagemErro(this.mensagem, {super.key});

  @override
  Widget build(BuildContext context) {
    if (mensagem == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(mensagem!,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error)),
    );
  }
}

class BotaoPrincipal extends StatelessWidget {
  final String texto;
  final bool carregando;
  final VoidCallback onPressed;

  const BotaoPrincipal({
    super.key,
    required this.texto,
    required this.carregando,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(backgroundColor: corPrincipal),
        onPressed: carregando ? null : onPressed,
        child: carregando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Text(texto),
      ),
    );
  }
}

String? validarEmail(String? v) {
  final email = (v ?? '').trim();
  if (email.isEmpty) return 'Informe o e-mail';
  final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  return ok ? null : 'E-mail inválido';
}
