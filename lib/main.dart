//inicio e configuro o app

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // gerado pelo comando: flutterfire configure
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/catalogo_viewmodel.dart';
import 'views/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CatalogoViewModel()),
      ],
      child: MaterialApp(
        title: 'Meu Catálogo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFE75480),
          scaffoldBackgroundColor: const Color(0xFFFFF5F8),
        ),
        home: const AuthGate(),
      ),
    );
  }
}
