import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final String date;
  final String text;
  final int likes;

  Comment({
    required this.userName,
    required this.avatarUrl,
    required this.date,
    required this.text,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 20,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(text),
          SizedBox(height: 8)
        ],
      ),
    );
  }
}

class CommentModel {
  final String userName;
  final String avatarUrl;
  final String date;
  final String text;
  final int likes;

  CommentModel({
    required this.userName,
    required this.avatarUrl,
    required this.date,
    required this.text,
    required this.likes,
  });
}
