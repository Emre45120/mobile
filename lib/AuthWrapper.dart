import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'loginPage.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // L'utilisateur est connecté, afficher l'application avec la navigation
            return child;
          } else {
            // L'utilisateur n'est pas connecté, afficher la page de connexion
            return LoginPage(scaffoldKey: GlobalKey<ScaffoldState>());
          }
        } else {
          // Afficher un indicateur de chargement pendant la vérification de l'état d'authentification
          return const CircularProgressIndicator();
        }
      },
    );
  }
}