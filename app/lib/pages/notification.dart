import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [
    {
      'username': 'Léo',
      'message': 'Bonjour',
      'time': 'Il y a 15 min',
    },
    {
      'username': 'Alice',
      'message': 'Salut',
      'time': 'Il y a 30 min',
    },
    {
      'username': 'Bob',
      'message': 'Coucou',
      'time': 'Il y a 1 heure',
    },
  ];

  void deleteAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B9678),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final username = notification['username'];
          final message = '$username vous a envoyé un message';
          final time = notification['time'];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(username[0]),
              ),
              title: Text(message),
              subtitle: Text(time),
            ),
          );
        },
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
        child: FloatingActionButton.extended(
          onPressed: deleteAllNotifications,
          icon: Icon(Icons.delete),
          label: Text(
            'Tout effacer',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
