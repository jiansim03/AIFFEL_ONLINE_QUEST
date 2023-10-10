import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final client_id = dotenv.env['CLIENT_ID']!;
  final client_pw = dotenv.env['CLIENT_SECRET']!;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translate App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TranslateScreen(client_id: client_id, client_pw:client_pw),
    );
  }
}

class TranslateScreen extends StatefulWidget {
  final String client_id;
  final String client_pw;

  TranslateScreen({required this.client_id, required this.client_pw});

  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _translatedText = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _translateText() async {
    final userInput = _textEditingController.text;
    if (userInput.isNotEmpty) {
      final translation =
          await translateText(userInput, 'ko', 'en'); // 번역할 언어를 여기에 지정하세요.
      setState(() {
        _translatedText = translation;
      });
    }
  }

  Future<String> translateText(
      String text, String sourceLanguage, String targetLanguage) async {
    final apiUrl = Uri.parse('https://openapi.naver.com/v1/papago/n2mt');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'X-Naver-Client-Id': widget.client_id,
      'X-Naver-Client-Secret': widget.client_pw,
    };

    final body = {
      'source': sourceLanguage,
      'target': targetLanguage,
      'text': text,
    };

    final response = await http.post(
      apiUrl,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final translatedText =
          decodedResponse['message']['result']['translatedText'];
      return translatedText ?? '';
    } else {
      throw Exception('Failed to translate text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translate App'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter text to translate',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _translateText,
                child: Text('Translate'),
              ),
              SizedBox(height: 16.0),
              Text(
                _translatedText,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
