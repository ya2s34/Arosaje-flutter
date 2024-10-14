import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/components/comments.dart';

class Publication extends StatefulWidget {
  final String userName;
  final String date;
  final List<String> imageNames;
  final int userId;
  final int linkedUserId;
  final int postId;
  final String description;
  final String linked_username;

  Publication({
    required this.userName,
    required this.date,
    required this.imageNames,
    required this.userId,
    required this.postId,
    required this.linkedUserId,
    required this.description,
    required this.linked_username,
  });

  @override
  _PublicationState createState() => _PublicationState();
}

class _PublicationState extends State<Publication> {
  List<Comment> comments = [];
  int _currentIndex = 0;
  int _commentCount = 10;
  int _likeCount = 100;

  @override
  void initState() {
    super.initState();
    fetchComments(widget.postId);
  }

  Future<void> fetchComments(int postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.190.1:3000/api/posts/comments/$postId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<Comment> fetchedComments = [];

      final List<dynamic> commentsData = responseData['comments'];
      print(responseData['comments']);
      commentsData.forEach((commentData) {
        Comment comment = Comment(
          userName: commentData['username'],
          text: commentData['commentary'],
          date: "",
          avatarUrl: "",
          likes: 2,
        );
        fetchedComments.add(comment);
      });

      setState(() {
        comments = fetchedComments;
        _commentCount = comments.length;
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    String formattedTime = '${dateTime.hour}:${dateTime.minute}';

    return '$formattedDate $formattedTime';
  }

  void _showCommentSection() async {
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          child: Text(
                            'Commentaires',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Column(
                          children: comments.map((comment) {
                            return Column(
                              children: [
                                Comment(
                                  userName: comment.userName,
                                  avatarUrl: comment.avatarUrl,
                                  date: comment.date,
                                  text: comment.text,
                                  likes: comment.likes,
                                ),
                                SizedBox(height: 8),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Ajouter un commentaire...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF3b9678)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        String commentText = commentController.text;
                        await postComment(
                            widget.postId, widget.userId, commentText);
                        commentController.clear();
                        fetchComments(widget.postId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3b9678),
                      ),
                      child: Text(
                        'Envoyer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> postComment(int postId, int userId, String commentary) async {
    Map<String, dynamic> commentData = {
      'postId': postId,
      'userId': userId,
      'commentary': commentary,
    };
    print(commentData);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = Uri.parse('http://192.168.190.1:3000/api/posts/comments');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(commentData),
      );
      if (response.statusCode == 201) {
        print('Comment posted successfully');
      } else {
        print('Failed to post comment. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting comment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Color(0xFFfcfcfc),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Container(
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(
                        widget.userName.substring(0, 2),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      formatDateTime(widget.date),
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(width: 40),
                    CircleAvatar(
                      child: Text(
                        widget.linked_username.substring(0, 2),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.linked_username,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: widget.imageNames.length,
                        controller: PageController(
                          initialPage: _currentIndex,
                          viewportFraction: 1.0,
                        ),
                        onPageChanged: (int index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return FutureBuilder<http.Response>(
                            future: fetchImage(widget.imageNames[index]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error loading image'),
                                );
                              } else {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        snapshot.data!.bodyBytes,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: SmoothPageIndicator(
                            controller: PageController(
                              initialPage: _currentIndex,
                              viewportFraction: 1.0,
                            ),
                            count: widget.imageNames.length,
                            effect: WormEffect(
                              dotColor: Colors.grey,
                              activeDotColor: Color(0xFF3b9678),
                              dotHeight: 8,
                              dotWidth: 8,
                              spacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _showCommentSection,
                      child: Row(
                        children: [
                          Icon(Icons.message),
                          SizedBox(width: 4),
                          Text('$_commentCount'),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Color(0xFF3b9678),
                        ),
                        SizedBox(width: 4),
                        Text('$_likeCount'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<http.Response> fetchImage(String imageName) async {
    final String url = 'http://192.168.190.1:3000/api/upload/$imageName';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return response;
    } catch (error) {
      throw Exception('Failed to load image: $error');
    }
  }
}
