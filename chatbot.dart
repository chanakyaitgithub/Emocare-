import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _userInput = TextEditingController();

  final List<Message> _messages = [];
  final Map<String, List<double>> _emotionScores = {
    'joy': [],
    'sad': [],
    'anger': [],
    'fear': [],
    'happy': [],
    'disgust': [],
    'surprise': [],
    'neutral': [],
  };

  int count = 0;

  Future<void> sendMessage() async {
    final message = _userInput.text;

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    final response = await _getChatbotResponse(message);

    setState(() {
      _messages.add(Message(isUser: false, message: response, date: DateTime.now()));
    });

    // Perform sentiment analysis for the sent message
    final sentimentResult = await _getSentimentResult(message);

    // Update emotion scores
    sentimentResult.forEach((key, value) {
      _emotionScores[key]?.add(value);
    });

    // Update count for 'sad' emotion
    count++;
    if (count >= 4) {
      _showImage();
      count = 0; // Reset count
      print('done'); // Print confirmation
      return; // Skip further execution
    }

    // Display the count
    print('Sad Emotion Count: $count');
  }

  Future<String> _getChatbotResponse(String userInput) async {
    final url = Uri.parse('http://127.0.0.1:5000/chat');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': userInput}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['response'];
    } else {
      throw Exception('Failed to fetch chatbot response');
    }
  }

  Future<Map<String, dynamic>> _getSentimentResult(String userInput) async {
    final url = Uri.parse('http://127.0.0.1:5000/predictSentiment');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': userInput}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch sentiment analysis result');
    }
  }

  void _showImage() {
    // Display image here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feeling Sad ?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Image.asset(
                'fan/imagg.jpg',
                width: 500, // Adjust width as needed
                height: 500, // Adjust height as needed
              ),
            ],
          ),
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emobot '),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('fan/bg5.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(1.0), BlendMode.dstATop),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                      isUser: message.isUser,
                      message: message.message,
                      date: DateFormat('HH:mm').format(message.date));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: _userInput,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Enter Your Message',
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    padding: EdgeInsets.all(12),
                    iconSize: 30,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepOrange),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(CircleBorder()),
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    Key? key,
    required this.isUser,
    required this.message,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
      decoration: BoxDecoration(
        color: isUser ? Colors.deepOrange : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: isUser ? Radius.circular(10) : Radius.zero,
          topRight: Radius.circular(10),
          bottomRight: isUser ? Radius.zero : Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 10,
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
