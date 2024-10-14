import 'package:flutter/material.dart';
import 'package:app/components/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './privacy.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B9678),
        title: const Text(
          'Paramètres',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text(
                    'Modifier profil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF3B9678),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            NotificationRow(),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Action à effectuer lorsque la ligne "Confidentialité" est cliquée
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPage()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.security), // Icône de bouclier
                  SizedBox(width: 8),
                  Text(
                    'Confidentialité',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF3B9678),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                // Action à effectuer lorsque la ligne "A propos" est cliquée
              },
              child: Row(
                children: [
                  Icon(Icons.info), // Icône d'information
                  SizedBox(width: 8),
                  Text(
                    'A propos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF3B9678),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CertificationRequestPage()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.back_hand),
                  SizedBox(width: 8),
                  Text(
                    'Je suis botaniste',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF3B9678),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Icon(Icons.mail), // Icône d'information
                  SizedBox(width: 8),
                  Text(
                    'Nous contacter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF3B9678),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    text: 'Déconnexion',
                    onPressed: () {
                      _logout(context);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationRow extends StatefulWidget {
  @override
  _NotificationRowState createState() => _NotificationRowState();
}

class _NotificationRowState extends State<NotificationRow> {
  bool _notificationValue = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.notifications),
            SizedBox(width: 8),
            Text(
              'Notification',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Transform.scale(
          scale: 0.8, // Réduire la taille du switch
          child: Switch(
            value: _notificationValue,
            onChanged: (value) {
              setState(() {
                _notificationValue = value;
              });
            },
            activeColor: Color(0xFF3B9678), // Changer la couleur en vert
          ),
        ),
      ],
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();

  void enregistrerChangements(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');
    String name = nomController.text;
    String motDePasse = motDePasseController.text;
    if (name.isEmpty || motDePasse.isEmpty) {
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
    if (userId != null && token != null) {
      String apiUrl = 'http://192.168.190.1:3000/api/users/$userId';

      String jsonData =
          jsonEncode({"first_name": name, "password": motDePasse});

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      final responseBody = jsonDecode(response.body);
      final message = responseBody['message'];

      if (message == 'User updated successfully') {
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Compte mis à jour avec succès!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        debugPrint('Erreur lors de la modification du compte: $message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B9678),
        title: const Text(
          'Modifier profil',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              child: ClipOval(
                child: Image.asset(
                  'assets/avatar1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF3B9678),
              ),
              child: Text('Changer la photo de profil'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: motDePasseController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                enregistrerChangements(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF3B9678),
              ),
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}

void _logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('userId');
  Navigator.pushReplacementNamed(context, '/connexion');
}

class CertificationRequestPage extends StatefulWidget {
  @override
  _CertificationRequestPageState createState() =>
      _CertificationRequestPageState();
}

class _CertificationRequestPageState extends State<CertificationRequestPage> {
  late DateTime _selectedDate;
  final TextEditingController _siretController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _updateBotaniste(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');
    String siret = _siretController.text;
    String companyName = _companyController.text;
    String companyDate = _startDateController.text;
    if (companyName.isEmpty || companyDate.isEmpty || siret.isEmpty) {
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
    if (userId != null && token != null) {
      String apiUrl = 'http://192.168.190.1:3000/api/users/botanist/$userId';

      String jsonData = jsonEncode({
        "companyName": companyName,
        "companyDate": companyDate,
        "siret": siret
      });

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      final responseBody = jsonDecode(response.body);
      final message = responseBody['success'];
      print(responseBody);
      if (message == true) {
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Demande envoyée avec succès!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (message == false) {
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 175, 172, 76),
            content: Text(
              'Une demande a déjà été soumise!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        debugPrint('Erreur lors de la modification du compte: $message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B9678),
        title: const Text(
          'Demande de certification',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _siretController,
              maxLength: 14,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Numéro de SIRET',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF3B9678),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _companyController,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Nom de l\'entreprise',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF3B9678),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _startDateController,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Date de début d\'activité',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF3B9678),
                  ),
                ),
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  text: 'Envoyer',
                  onPressed: () {
                    _updateBotaniste(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
