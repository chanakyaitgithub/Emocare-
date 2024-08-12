import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'message.dart';

class ChatPage extends StatefulWidget {
  final String email;

  ChatPage({required this.email});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  bool _showImage = false;
  int count = 0;
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
                color: Colors.deepOrange,
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
              'fan/bg5.png', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Message(email: widget.email), // Use Message widget
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
                hintStyle: TextStyle(
                    color: Colors.white), // Change hint text color to white
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
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

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      final url = Uri.parse('http://localhost:3000/messages');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender': widget.email,
          'message': messageText,
        }),
      );

      if (response.statusCode == 201) {
        _messageController.clear();
        try {
          Map<String, dynamic> sentimentResult =
              await performSentimentAnalysis(messageText);
          sentimentResult.forEach((key, value) {
            if (_emotionScores.containsKey(key)) {
              double parsedValue = double.tryParse(value.toString()) ?? 0.0;
              _emotionScores[key]?.add(parsedValue);
            }
          });

          setState(() {
            double highestValue = 0.0;
            highestEmotion = '';
            sentimentResult.forEach((key, value) {
              double parsedValue = double.tryParse(value.toString()) ?? 0.0;
              if (parsedValue > highestValue) {
                highestValue = parsedValue;
                highestEmotion = key;
              }
            });

            if (highestEmotion == 'sad' && count >= 4) {
              _showImage = true;
              count = 0;
            } else {
              _showImage = false;
              if (highestEmotion == 'sad') {
                count++;
              }
            }
          });
        } catch (e) {
          print('Error performing sentiment analysis: $e');
        }
      } else {
        print('Failed to send message');
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
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch sentiment analysis result');
    }
  }

  void _updateEmotionScores() {
    final Map<String, double> averageEmotionScores = {};

    _emotionScores.forEach((key, value) {
      final totalScore = value.isNotEmpty ? value.reduce((a, b) => a + b) : 0;
      final totalCount = value.length;
      averageEmotionScores[key] = totalCount != 0 ? totalScore / totalCount : 0;
    });

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
