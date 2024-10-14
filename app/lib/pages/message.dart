import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false, // Supprimer la flèche de retour
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Text(conversation.user.substring(0, 1)),
                ),
                title: Text(conversation.user),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(conversation.lastMessage),
                    Text(conversation.time), // Temps d'envoi du message
                  ],
                ),
                onTap: () {
                  // Naviguer vers la vue de la conversation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ConversationPage(conversation: conversation),
                    ),
                  );
                },
              ),
              Divider(), // Ajouter une ligne de séparation
            ],
          );
        },
      ),
    );
  }
}

class ConversationPage extends StatefulWidget {
  final Conversation conversation;

  ConversationPage({required this.conversation});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController _messageController = TextEditingController();
  List<Message> _chatMessages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    String messageContent = _messageController.text.trim();
    if (messageContent.isNotEmpty) {
      Message newMessage = Message(
        sender: widget.conversation.user,
        content: messageContent,
        time_message: DateFormat('HH:mm').format(DateTime.now()),
      );
      setState(() {
        _chatMessages.add(newMessage);
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B9678),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Text(widget.conversation.user.substring(0, 1)),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(right: 45),
                child: Text(
                  widget.conversation.user,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:
                  widget.conversation.messages.length + _chatMessages.length,
              itemBuilder: (context, index) {
                if (index < widget.conversation.messages.length) {
                  final message = widget.conversation.messages[index];
                  final isSender = message.sender == widget.conversation.user;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: isSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          ChatBubble(
                            clipper: ChatBubbleClipper4(
                              type: !isSender
                                  ? BubbleType.receiverBubble
                                  : BubbleType.sendBubble,
                            ),
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 20),
                            backGroundColor: isSender
                                ? const Color(0xFF3B9678)
                                : Colors.grey[300],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    color:
                                        isSender ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: isSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: isSender
                                ? EdgeInsets.only(right: 10)
                                : EdgeInsets.only(left: 10),
                            child: Text(
                              message.time_message,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  final chatMessage = _chatMessages[
                      index - widget.conversation.messages.length];
                  final isSender =
                      chatMessage.sender == widget.conversation.user;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: isSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          ChatBubble(
                            clipper: ChatBubbleClipper4(
                              type: !isSender
                                  ? BubbleType.receiverBubble
                                  : BubbleType.sendBubble,
                            ),
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 20),
                            backGroundColor: isSender
                                ? const Color(0xFF3B9678)
                                : Colors.grey[300],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatMessage.content,
                                  style: TextStyle(
                                    color:
                                        isSender ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: isSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: isSender
                                ? EdgeInsets.only(right: 10)
                                : EdgeInsets.only(left: 10),
                            child: Text(
                              chatMessage.time_message,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF3B9678)),
                      ),
                    ),
                    cursorColor: Color(0xFF3B9678),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Envoyer'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF3B9678)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Conversation {
  final String user;
  final String lastMessage;
  final String time;
  final List<Message> messages;

  Conversation(
      {required this.user,
      required this.lastMessage,
      required this.time,
      required this.messages});
}

class Message {
  final String sender;
  final String content;
  final String time_message;

  Message(
      {required this.sender,
      required this.content,
      required this.time_message});
}

// Exemple de données de conversation
List<Conversation> conversations = [
  Conversation(
    user: 'Utilisateur 1',
    lastMessage: 'Bonjour',
    time: '15:02', // Temps d'envoi du dernier message
    messages: [
      Message(
          sender: 'Utilisateur 1', content: 'Bonjour', time_message: '15:02'),
      Message(sender: 'Utilisateur 2', content: 'Salut', time_message: '15:03'),
      Message(
          sender: 'Utilisateur 1',
          content: 'Comment ça va ?',
          time_message: '15:07'),
    ],
  ),
  Conversation(
    user: 'Utilisateur 2',
    lastMessage: 'Salut',
    time: '17:01', // Temps d'envoi du dernier message
    messages: [
      Message(sender: 'Utilisateur 2', content: 'Salut', time_message: '17:01'),
      Message(
          sender: 'Utilisateur 1', content: 'Bonjour', time_message: '17:10'),
    ],
  ),
  Conversation(
    user: 'Utilisateur 3',
    lastMessage: 'Hey',
    time: '19:12',
    messages: [
      Message(sender: 'Utilisateur 3', content: 'Hey', time_message: '19:12'),
      Message(sender: 'Utilisateur 1', content: 'Salut', time_message: '20:15'),
    ],
  ),
];
