import 'package:app/components/publication.dart';
import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('userId');
    String? token = prefs.getString('token');
    final url = Uri.parse('http://192.168.190.1:3000/api/posts');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _posts = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Failed to load posts');
    }
  }

  Future<String> fetchUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');

    final url = Uri.parse('http://192.168.190.1:3000/api/users/$userId');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final firstName = jsonData['first_name'];
      final lastName = jsonData['last_name'];
      final userName = '$firstName $lastName';
      return userName;
    } else {
      throw Exception('Failed to fetch user name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B9678),
        title: const Text(
          'Profil',
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: FutureBuilder<String>(
                        future: fetchUserName(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String initials = snapshot.data!.substring(0, 2);
                            return Text(
                              initials,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Failed to fetch user name');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    FutureBuilder<String>(
                      future: fetchUserName(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Failed to fetch user name');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '72%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B9678),
                      ),
                    ),
                    Text(
                      'Taux de réponse',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Publications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: _posts.map((post) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Publication(
                        postId: post["post_id"],
                        userName: post['user_name'],
                        date: post['date'],
                        imageNames: List<String>.from(post['images']),
                        userId: post['user_id'],
                        linkedUserId: post['linked_user_id'],
                        linked_username: post['linked_username'],
                        description: post['description'],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
