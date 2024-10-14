import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/components/publication.dart';
import 'package:app/pages/message.dart';
import 'package:app/pages/post.dart';
import 'package:app/pages/search.dart';
import 'package:app/components/bottomNavbar.dart';
import 'package:app/components/bottomNavbar.dart';
import 'package:app/components/publication.dart';
import 'package:app/pages/notification.dart';
import 'package:app/pages/profil.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/message.dart';
import 'package:app/pages/post.dart';
import 'package:app/pages/search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomBar(
        onPageChanged: _onPageChanged,
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _fetchPosts();
    });
  }

  Future<void> _fetchPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');
    final userUrl = Uri.parse('http://192.168.190.1:3000/api/posts');
    final response = await http.get(
      userUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _posts = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Failed to load posts');
    }
  }

  List<Widget> get _pages {
    return [
      HomePageContent(posts: _posts),
      SearchPage(),
      MessagePage(),
      PostPage(),
    ];
  }
}

class HomePageContent extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  HomePageContent({required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'A\'ROSAJE',
          style: TextStyle(
            color: Color(0xFF3b9678),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: posts.map((post) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Publication(
                  postId: post['post_id'],
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
    );
  }
}
