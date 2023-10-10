import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Modulabs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 변수 목록
  final _controller = TextEditingController();
  TranslateLanguage _sourceLanguage = TranslateLanguage.english; // 번역할 언어
  TranslateLanguage _targetLanguage = TranslateLanguage.korean; // 도착어
  late final _onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);
  final _translationController = StreamController<String>();

  bool _cameraIsBusy = false;
  bool _recognitionIsBusy = false;

  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool isBusy = false;
  String? _text; // 인식된 텍스트를 저장
  final ImagePicker _picker = ImagePicker();
  late CameraController _cameraController;

  late final stt.SpeechToText _speechToText;

  @override
  // 번역 후 컨트롤러를 비워준다
  void dispose() {
    _translationController.close();
    _onDeviceTranslator.close();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
    _initializeSpeechToText();
  }

  // 카메라 초기화
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first; // 기본 카메라 어플 쓰도록 강제함

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium, // 중간해상도 사용
    );

    _cameraController.initialize().then((_) {
      if (!mounted) {
        // 기본 카메라가 마운트 안되어있으면 빈 값 반환
        return;
      }
      setState(() {});
    });
  }

  Future<void> captureAndRecognizeText() async {
    if (_recognitionIsBusy) return; // 이미 인식기가 사용중이라면 사용 X
    _recognitionIsBusy = true; // 사용중으로 상태 전환

    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera); // 카메라에서 찍은 사진을 가져와 변수에 담기
    if (image != null) {
      _recognizeText(
          InputImage.fromFilePath(image.path)); // Null이 아니라면 파일 경로 받아와 이미지 인식하기
    }
    _recognitionIsBusy = false;
  }

  // 인식기에서 결과 받아 _controller에 저장
  Future<void> _recognizeText(InputImage inputImage) async {
    _recognitionIsBusy = true;
    final recognizedText = await _textRecognizer.processImage(inputImage);
    _controller.text = recognizedText.text;

    _recognitionIsBusy = false;
  }

//  음성인식변환기 초기화
  Future<void> _initializeSpeechToText() async {
    _speechToText = stt.SpeechToText();
    await _speechToText.initialize();

  }

// 음성인식 기능
  void startListening() {
    print('음성인식 시작');
    _speechToText.listen(// 음성인식 시작
        onResult: (result) {
      // result : 음성인식 결과. 사용가능할때마다 호춢됨
      setState(() {
        _controller.text = result.recognizedWords;
        print('인식결과${result.recognizedWords}');
      });
    });
  }

// 음성인식 종료
  void stopListening() {
    _speechToText.stop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 45.0,
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: DropdownButtonFormField<TranslateLanguage>(
                      value: _sourceLanguage,
                      onChanged: (value) {
                        setState(() {
                          _sourceLanguage = value!;
                          print(_sourceLanguage);
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text('영어'),
                          value: TranslateLanguage.english,
                        ),
                        DropdownMenuItem(
                          child: Text('한국어'),
                          value: TranslateLanguage.korean,
                        ),
                        DropdownMenuItem(
                          child: Text('일본어'),
                          value: TranslateLanguage.japanese,
                        ),
                        DropdownMenuItem(
                          child: Text('중국어'),
                          value: TranslateLanguage.chinese,
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: '소스 언어',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: DropdownButtonFormField<TranslateLanguage>(
                      value: _targetLanguage,
                      onChanged: (value) {
                        setState(() {
                          _targetLanguage = value!;
                          print(_targetLanguage);
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text('영어'),
                          value: TranslateLanguage.english,
                        ),
                        DropdownMenuItem(
                          child: Text('한국어'),
                          value: TranslateLanguage.korean,
                        ),
                        DropdownMenuItem(
                          child: Text('일본어'),
                          value: TranslateLanguage.japanese,
                        ),
                        DropdownMenuItem(
                          child: Text('중국어'),
                          value: TranslateLanguage.chinese,
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: '타겟 언어',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: '번역할 내용을 입력하세요', border: InputBorder.none),
              onSubmitted: (text) async {
                final translation = await _onDeviceTranslator
                    .translateText(text); // 로컬로 받은 언어가 번역됨
                _translationController.add(translation); // 컨트롤러에 번역결과를 추가해줌
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<String>(
              stream: _translationController.stream, // 어떤 스트림을 받을지
              builder: (context, snapshot) {
                return Center(
                    child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    snapshot.data ?? '',
                    // snapshot의 데이터가 있으면 받아오고 없으면 ''(빈값)을 반환
                    style: const TextStyle(
                        fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ));
              }, // 무엇을 만들지
            ), // 스트림값을 받아 나중에 화면을 그려주도록 하는 위젯
          ),
          // 텍스트 인식 버튼
          InkWell(
            onTap: () {
              captureAndRecognizeText();
            },
            child: Container(
              alignment: Alignment.center,
              height: 75,
              color: Colors.yellow,
              child: const Icon(Icons.search),
            ),
          ),
          // 음성 버튼
          InkWell(
            onTap: () {
              if (_speechToText.isListening) {
                stopListening();
              } else {
                print('음성인식 버튼 감지');
                startListening();
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 75,
              color: Colors.orange,
              child: const Icon(Icons.mic),
            ),
          ),
        ],
      ),
    );
  }
}
