import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentiment Analysis & Paraphrase Demo',
      debugShowCheckedModeBanner: false,
      home: const SentimentAnalysisScreen(),
    );
  }
}

class SentimentAnalysisScreen extends StatefulWidget {
  const SentimentAnalysisScreen({Key? key}) : super(key: key);

  @override
  _SentimentAnalysisScreenState createState() =>
      _SentimentAnalysisScreenState();
}

class _SentimentAnalysisScreenState extends State<SentimentAnalysisScreen> {
  TextEditingController _userInput = TextEditingController();
  String? _highestEmotion;

  Future<void> _getSentimentResult(String userInput) async {
    final url = Uri.parse('http://localhost:5000/predictSentiment');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': userInput}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> sentimentResult = json.decode(response.body);

      // Find the emotion with the highest value
      double maxValue = double.negativeInfinity;
      String? highestEmotion;
      sentimentResult.forEach((key, value) {
        if (value > maxValue) {
          maxValue = value;
          highestEmotion = key;
        }
      });

      setState(() {
        _highestEmotion = highestEmotion;
      });

      // Navigate to the paraphrase screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParaphraseScreen(userInput: userInput),
        ),
      );
    } else {
      throw Exception('Failed to fetch sentiment analysis result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentiment Analysis'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('fan/bg6.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _userInput,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black, // Change the color here
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _getSentimentResult(_userInput.text);
                    },
                    child: Text('Analyze Sentiment & Paraphrase'),
                  ),
                  SizedBox(height: 20),
                  if (_highestEmotion != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Highest Emotion: $_highestEmotion',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
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

class ParaphraseScreen extends StatefulWidget {
  final String userInput;
  const ParaphraseScreen({Key? key, required this.userInput}) : super(key: key);

  @override
  _ParaphraseScreenState createState() => _ParaphraseScreenState();
}

class _ParaphraseScreenState extends State<ParaphraseScreen> {
  final TextEditingController _textController = TextEditingController();
  String _paraphrasedText = '';
  bool _isLoading = false;

  Future<void> paraphraseText() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://127.0.0.1:5000/paraphrase');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': widget.userInput}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _paraphrasedText = responseData['paraphrase'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _paraphrasedText = 'Error: Unable to paraphrase text';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paraphrase Demo'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('fan/bg5.png'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(1.0), BlendMode.dstATop),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Original Message: ${widget.userInput}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: paraphraseText,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : const Text('Paraphrase'),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _paraphrasedText,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
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
