import 'package:flutter/material.dart';
import 'chatpage.dart'; // Import your ChatPage implementation
import 'chatbot.dart'; // Import your Chatbot implementation
import 'paraphase.dart'; // Import the ParaphraseScreen implementation

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Selection',
      theme: ThemeData(
        primarySwatch: Color.fromARGB(255, 16, 233, 139),
      ),
      home: HomeScreen(email: 'example@gmail.com'), // Pass the email here
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String email; // Email parameter

  const HomeScreen({required this.email}); // Constructor with email parameter

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<double>> _chatAppEmotionScores = {};
  Map<String, List<double>> _chatbotEmotionScores = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Mode'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'fan/m1.jpeg', // Replace with your background image asset path
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final scores = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(email: widget.email),
                      ),
                    );
                    if (scores != null) {
                      setState(() {
                        _chatAppEmotionScores = scores;
                      });
                    }
                  },
                  child: Text('Chat App',
                      style: TextStyle(color: Color.fromARGB(255, 16, 233, 139))),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final scores = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                    if (scores != null) {
                      setState(() {
                        _chatbotEmotionScores = scores;
                      });
                    }
                  },
                  child: Text('Chatbot',
                      style: TextStyle(color: Color.fromARGB(255, 16, 233, 139))),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showHRView();
                  },
                  child: Text(
                    'HR View',
                    style: TextStyle(color: Color.fromARGB(255, 16, 233, 139)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SentimentAnalysisScreen(),
                      ),
                    );
                  },
                  child: Text('EmoCorrect',
                      style: TextStyle(
                          color: Color.fromARGB(255, 16, 233, 139))), // Button for EmoCorrect
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                Color.fromARGB(255, 16, 233, 139),
              ),
              child: Text('Sentiment Analysis Results'),
            ),
            ListTile(
              title: Text('Chat App Sentiment Analysis Result (Average)'),
              onTap: () {
                _showHRView();
              },
            ),
            ..._chatAppEmotionScores.entries.map((entry) {
              return ListTile(
                title: Text(
                    '${entry.key}: ${_calculateAverage(entry.value).toStringAsFixed(2)}'),
              );
            }).toList(),
            ListTile(
              title: Text('Chatbot Sentiment Analysis Result (Average)'),
              onTap: () {
                _showHRView();
              },
            ),
            ..._chatbotEmotionScores.entries.map((entry) {
              return ListTile(
                title: Text(
                    '${entry.key}: ${_calculateAverage(entry.value).toStringAsFixed(2)}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showHRView() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('HR View'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chat App Sentiment Analysis Result (Average):'),
              ..._chatAppEmotionScores.entries.map((entry) {
                return Text(
                    '${entry.key}: ${_calculateAverage(entry.value).toStringAsFixed(2)}');
              }).toList(),
              SizedBox(height: 10),
              Text('Chatbot Sentiment Analysis Result (Average):'),
              ..._chatbotEmotionScores.entries.map((entry) {
                return Text(
                    '${entry.key}: ${_calculateAverage(entry.value).toStringAsFixed(2)}');
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  double _calculateAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    final sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }
}
