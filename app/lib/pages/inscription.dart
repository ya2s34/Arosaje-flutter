import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/components/button.dart';
import 'package:flutter/services.dart';

String? apiUrl = DotEnv().env['API_URL'];

class InscriptionPage extends StatelessWidget {
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmationMotDePasseController =
      TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();

  bool passwordsMatch = true;

  String validatePasswords() {
    String password = _motDePasseController.text;
    String confirmPassword = _confirmationMotDePasseController.text;
    bool match = password == confirmPassword;

    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    bool passwordIsValid = regExp.hasMatch(password);

    if (!match) {
      return 'Les mots de passe ne correspondent pas';
    } else if (!passwordIsValid) {
      return 'Le mot de passe doit contenir au moins 8 caractères, une lettre majuscule, une lettre minuscule, un chiffre et un symbole';
    } else {
      return '';
    }
  }

  void inscription(BuildContext context) async {
    String prenom = _prenomController.text;
    String nom = _nomController.text;
    String email = _emailController.text;
    String motDePasse = _motDePasseController.text;
    String adresse = _adresseController.text;
    String ville = _villeController.text;
    String codePostal = _codePostalController.text;

    String passwordError = validatePasswords();
    if (passwordError.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            passwordError,
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    if (prenom.isEmpty ||
        nom.isEmpty ||
        email.isEmpty ||
        motDePasse.isEmpty ||
        adresse.isEmpty ||
        ville.isEmpty ||
        codePostal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Veuillez remplir tous les champs',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    const url = 'http://192.168.190.1:3000/api/auth/signup';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "first_name": prenom,
        "last_name": nom,
        "phone": "0788037621",
        "address": adresse,
        "zip_code": codePostal,
        "city": ville,
        "email": email,
        "password": motDePasse
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      final successMessage = responseBody['success'];

      if (successMessage == 'User created successfully') {
        debugPrint('Utilisateur créé avec succès');
        Navigator.pushReplacementNamed(context, '/connexion');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Votre compte a été créé avec succès, veuillez vous connecter',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        debugPrint(
            'Erreur lors de la création de l\'utilisateur: $successMessage');
      }
    } else {
      final responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['error'];

      if (errorMessage == 'User already exists') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Utilisateur existe déjà')),
        );
      } else {
        debugPrint(
            'Erreur lors de la création de l\'utilisateur: $errorMessage');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B9678),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: Container(
          padding: const EdgeInsets.only(
            top: 40.0,
            bottom: 20.0,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.arrowtriangle_left_circle_fill,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/sliderStart');
              },
            ),
            title: const Text(
              'Créer un compte',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 247, 247, 247),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Rejoignez une communauté passionnée, partagez vos plantes, recevez des conseils experts',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8F8F8F),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _prenomController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFF3B9678),
                      ),
                    ),
                    hintText: 'Prénom',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFF3B9678),
                      ),
                    ),
                    hintText: 'Nom',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF3B9678)),
                      ),
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 10),
                TextField(
                  controller: _motDePasseController,
                  obscureText: true, // Rend le texte du mot de passe masqué
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFF3B9678)),
                    ),
                    hintText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmationMotDePasseController,
                  obscureText: true, // Rend le texte du mot de passe masqué
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFF3B9678)),
                    ),
                    hintText: 'Confirmer le mot de passe',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _adresseController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFF3B9678)),
                    ),
                    hintText: 'Adresse',
                    prefixIcon: Icon(Icons.house),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _villeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFF3B9678)),
                    ),
                    hintText: 'Ville',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _codePostalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // N'autorise que les chiffres
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFF3B9678)),
                    ),
                    hintText: 'Code Postal',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Inscription',
                  onPressed: () {
                    inscription(context);
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Vous avez déjà un compte ? ',
                      style: TextStyle(
                        color: Color(0xFF8F8F8F),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Connexion',
                          style: TextStyle(
                            color: Color(0xFF3B9678),
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/connexion');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
