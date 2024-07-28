import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String email;

  ChatPage({required this.email});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int count = 0;
  bool _showImage = false;
  String highestEmotion = '';
  Map<String, List<double>> _emotionScores = {
    'joy': [],
    'sad': [],
    'anger': [],
    'fear': [],
    'happy': [],
    'disgust': [],
    'surprise': [],
    'neutral': [],
  };

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 16, 233, 139),
              ),
              child: Text('Sentiment Analysis Results'),
            ),
            ListTile(
              title: Text('View Sentiment Analysis Result'),
              onTap: () {
                _updateEmotionScores();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'fan/m3.jpeg', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: _buildMessageList(), // Use StreamBuilder for messages
              ),
              _buildMessageInput(),
              ElevatedButton(
                onPressed: () {
                  _updateEmotionScores();
                },
                child: Text('View Sentiment Analysis Result'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Change the color here
                    ),
                  )),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.deepOrange,
            ),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: widget.email == messageSender,
            showImage: _showImage,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      _firestore.collection('messages').add({
        'text': messageText,
        'sender': widget.email,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();

      // Perform sentiment analysis if message text is not null
      try {
        if (messageText != null) {
          Map<String, dynamic> sentimentResult =
              await performSentimentAnalysis(messageText);
          // Add sentiment analysis result to emotion scores
          sentimentResult.forEach((key, value) {
            if (_emotionScores.containsKey(key)) {
              _emotionScores[key]?.add(value);
            }
          });
          setState(() {
            // Track highest emotion
            if (sentimentResult['label'] != null) {
              highestEmotion = sentimentResult['label'];
            }
            // Check if the highest emotion is sad and count exceeds threshold
            if (highestEmotion == 'sad' && count >= 4) {
              _showImage = true;
              count = 0;
            } else {
              _showImage = false;
              // Increment count if emotion is sad
              if (highestEmotion == 'sad') {
                count++;
              }
            }
          }); // Refresh UI
        }
      } catch (e) {
        print('Error performing sentiment analysis: $e');
        // Handle error here
      }
    }
  }

  Future<Map<String, dynamic>> performSentimentAnalysis(String text) async {
    final url = Uri.parse('http://localhost:5000/predictSentiment');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch sentiment analysis result');
    }
  }

  void _updateEmotionScores() {
    // Calculate the average score for each emotion class
    final Map<String, double> averageEmotionScores = {};

    _emotionScores.forEach((key, value) {
      final totalScore = value.isNotEmpty ? value.reduce((a, b) => a + b) : 0;
      final totalCount = value.length;
      averageEmotionScores[key] = totalCount != 0 ? totalScore / totalCount : 0;
    });

    // Display the average scores
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sentiment Analysis Result (Average)'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: averageEmotionScores.entries.map((entry) {
              return Text('${entry.key}: ${entry.value.toStringAsFixed(2)}');
            }).toList(),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final bool showImage;

  MessageBubble(
      {required this.sender,
      required this.text,
      required this.isMe,
      required this.showImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Color.fromARGB(255, 16, 233, 139) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$text',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                  if (!isMe && showImage) // Show image conditionally
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        'fan/imagg.jpg',
                        width: 200, // Adjust width as needed
                        height: 200, // Adjust height as needed
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
