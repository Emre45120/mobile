import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SAE/main.dart';
import 'main.dart';
import 'RegisterPage.dart';


class LoginPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const LoginPage({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();

  Future<UserCredential?> _login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Aucun utilisateur trouvé avec cet email.');
      } else if (e.code == 'wrong-password') {
        print('Mot de passe incorrect.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Identifiant',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            // Ajoutez le champ de mot de passe de confirmation ici:
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final userCredential = await _login(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (userCredential != null) {
                  // L'utilisateur est connecté
                  print('Utilisateur connecté: ${userCredential.user}');
                  // Afficher un message indiquant que l'utilisateur s'est connecté avec succès
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connexion réussie')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur lors de la connexion')),
                  );
                }
              },
              child: const Text('Se connecter'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text("Pas encore de compte ? S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Ajoutez cette ligne
    super.dispose();
  }

}
