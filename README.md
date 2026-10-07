# Meu Catálogo

Aplicativo Flutter para consultar produtos de maquiagem, pesquisar itens e gerenciar favoritos. A autenticação usa Firebase Authentication com e-mail e senha.

## Requisitos

- Flutter SDK
- Um projeto Firebase com o provedor de autenticação por e-mail/senha ativado

## Executar no navegador

```powershell
flutter pub get
flutter run -d chrome
```

O Firebase está configurado para Web em `lib/firebase_options.dart`. Para adicionar outras plataformas, execute `flutterfire configure` na raiz do projeto e selecione as plataformas desejadas.

## Configurar autenticação

No Firebase Console, abra **Authentication > Sign-in method** e habilite **Email/Password**.