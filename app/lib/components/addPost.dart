import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  final String userName;
  final String avatarImage;

  AddPost({required this.userName, required this.avatarImage});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isCheckboxChecked1 = false;
  bool isCheckboxChecked2 = false;
  String selectedPlantType = 'Sélectionnez une catégorie';
  late String selectedImagePath = '';
  late String selectedImageName = '';
  late String location = '';

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _RechercherController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _villeController = TextEditingController();

  List<String> plantTypes = [
    'Sélectionnez une catégorie',
    'Fleurs',
    'Légumes',
    'Fruits',
    'Herbes',
  ];

  List<UserData> userNames = []; // Liste des noms d'utilisateurs
  UserData? selectedUser; // Utilisateur sélectionné dans le sélecteur

  @override
  void initState() {
    super.initState();
    fetchUserNames(); // Charger les noms d'utilisateurs au démarrage
  }

  Future<void> fetchUserNames() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? currentUserId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      final url = Uri.parse('http://192.168.190.1:3000/api/users/usernames');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      List<dynamic> data = json.decode(response.body);
      print(data);

      setState(() {
        userNames = data
            .where((item) => item['userId'] != currentUserId)
            .map((item) => UserData(
                  userId: item['userId'],
                  userName: item['userName'],
                ))
            .toList();
      });
    } catch (e) {
      print('Error fetching user names: $e');
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
      location = jsonData['city'];
      final userName = '$firstName $lastName';
      return userName;
    } else {
      throw Exception('Failed to fetch user name');
    }
  }

  Future<String?> uploadImage(int postId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = Uri.parse('http://192.168.190.1:3000/api/upload');
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data"
      });

      request.fields['post_id'] = postId.toString();

      request.files
          .add(await http.MultipartFile.fromPath('image', selectedImagePath));

      var response = await request.send();

      if (response.statusCode == 201) {
        String responseBody = await response.stream.bytesToString();
        final responseData = json.decode(responseBody);
        return responseBody;
      } else {
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Color getRandomColor() {
    Random random = Random();
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    return Color.fromARGB(255, r, g, b);
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisir une source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Prendre une photo'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
                SizedBox(height: 16),
                GestureDetector(
                  child: Text('Choisir depuis la galerie'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      final XFile? image = await ImagePicker().pickImage(source: source);

      if (image != null) {
        // Générer un nom unique pour l'image en utilisant la date et l'heure actuelles
        DateTime now = DateTime.now();
        String timestamp =
            '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
        String imageName = 'img_$timestamp';

        setState(() {
          selectedImagePath = image.path;
          selectedImageName = imageName;
        });
      }
    }
  }

  Future<void> createPost() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      final userUrl = Uri.parse('http://192.168.190.1:3000/api/users/$userId');
      final userResponse = await http.get(
        userUrl,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userResponse.statusCode == 200) {
      } else {
        throw Exception('Failed to fetch user data');
      }
      String location = _villeController.text;
      String title = _titleController.text;
      String description = _descriptionController.text;
      String rechercher = _RechercherController.text;

      DateTime now = DateTime.now();
      bool isProgressPost = isCheckboxChecked1;
      String category = selectedPlantType;

      Map<String, dynamic> postData = {
        'title': title,
        'location': location,
        'description': description,
        'date': now.toIso8601String(),
        'isProgress_post': isProgressPost ? 1 : 0,
        'category': category,
        'user_id': userId
      };

      if (isProgressPost) {
        postData['linked_user_id'] = rechercher;
      }

      final url = Uri.parse('http://192.168.190.1:3000/api/posts');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(postData),
      );

      if (response.statusCode == 201) {
        print('Post créé avec succès');
        print('Response body: ${response.body}');

        final responseBody = json.decode(response.body);
        final postId = responseBody['postId'];

        String? uploadResult = await uploadImage(postId);
        if (uploadResult != null) {
          print('Success: $uploadResult');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Post créé avec succès',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          print('Error: Failed to upload image');
        }
        setState(() {
          _descriptionController.clear();
          _RechercherController.clear();
          isCheckboxChecked1 = false;
          selectedPlantType = 'Sélectionnez une catégorie';
          selectedImagePath = "";
          isCheckboxChecked2 = false;
        });
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: FutureBuilder<String>(
                        future: fetchUserName(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String userName = snapshot.data!;
                            String initials = userName.isNotEmpty
                                ? userName.substring(0, 2).toUpperCase()
                                : '';
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
                    SizedBox(width: 8),
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isCheckboxChecked1,
                      onChanged: (value) {
                        setState(() {
                          isCheckboxChecked1 = value ?? false;
                          if (isCheckboxChecked1) {
                            isCheckboxChecked2 = false;
                          }
                        });
                      },
                      activeColor: Color(0xFF3B9678),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Je publie un suivi',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                if (isCheckboxChecked1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'En lien avec :',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: DropdownButton<UserData>(
                              value: selectedUser,
                              onChanged: (UserData? newValue) {
                                setState(() {
                                  selectedUser = newValue!;
                                  _RechercherController.text =
                                      selectedUser?.userId.toString() ?? '';
                                });
                              },
                              items: userNames.map((UserData user) {
                                return DropdownMenuItem<UserData>(
                                  value: user,
                                  child: Text(' ${user.userName}'),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (!isCheckboxChecked1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      TextField(
                        controller: _villeController,
                        onChanged: (value) {
                          // Do something with the value
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Entrez la ville du poste...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF3B9678),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF3B9678),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  onChanged: (value) {
                    // Do something with the value
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Entrez le titre de l\'annonce...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF3B9678),
                      ),
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
                  controller: _descriptionController,
                  onChanged: (value) {
                    // Do something with the value
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Écrivez votre message...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF3B9678),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF3B9678),
                      ),
                    ),
                  ),
                  maxLines: 4,
                ),
                if (!isCheckboxChecked1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Type de plante :',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        value: selectedPlantType,
                        onChanged: (newValue) {
                          setState(() {
                            selectedPlantType = newValue!;
                          });
                        },
                        items: plantTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                SizedBox(height: 16),
                if (selectedImagePath != null)
                  Text(
                    'Image sélectionnée : ${selectedImageName}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Choisir une image'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF3B9678)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        createPost();
                      },
                      child: Text(selectedImagePath != null
                          ? 'Publier'
                          : 'Choisir une image'),
                      isChecked: true,
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
}

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isChecked;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.isChecked,
  }) : super(key: key);

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  late Color buttonColor;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.isChecked ? Color(0xFF3B9678) : Colors.grey;
  }

  @override
  void didUpdateWidget(covariant CustomElevatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    buttonColor = widget.isChecked ? Color(0xFF3B9678) : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isChecked ? widget.onPressed : null,
      child: widget.child,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: AddPost(
        userName: 'John Doe',
        avatarImage: 'assets/avatar.png',
      ),
    ),
  ));
}

class UserData {
  final int userId;
  final String userName;

  UserData({required this.userId, required this.userName});
}
