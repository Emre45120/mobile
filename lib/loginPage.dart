import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<String?> _login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['token'];
    } else {
      throw Exception('Erreur lors de la connexion');
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final token = await _login(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (token != null) {
                  // Vous pouvez utiliser le token ici pour accéder à d'autres parties de l'application
                  print('Token: $token');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur lors de la connexion')),
                  );
                }
              },
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
