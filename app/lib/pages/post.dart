import 'package:app/components/addPost.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 55),
            AddPost(
              userName: 'John Doe',
              avatarImage: 'assets/avatar.png',
            ),
          ],
        ),
      ),
    );
  }
}
