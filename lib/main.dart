import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueAccent.shade400,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("The Oracle"),
            ],
          ),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        body: const MagicBallPage(),
      ),
    );
  }
}

class MagicBallPage extends StatefulWidget {
  const MagicBallPage({super.key});

  @override
  State<MagicBallPage> createState() => _MagicBallPageState();
}

class _MagicBallPageState extends State<MagicBallPage> {
  /// This Class is designed to
  /// - read assets from Asset bundle
  /// - show loading page while assets are being read
  /// - pick random file for answer
  ///
  /// Properties:
  /// - possibleAnswers: array of strings containing location of magic ball
  ///   response files
  /// - possibleAnswersLength: number of elements in possibleAnswers
  /// - answer: randomly selected answer image
  ///
  /// Members:
  /// - _magicBallAnswers: private function to load asserts and select paths that starts
  ///   with assets/magic_balls , it also sets possibleAnswers and,
  ///   possibleAnswersLength
  /// - randomAnswer: function to select random asset from possibleAnswers and
  ///   sets answer
  List<String> possibleAnswers = [];
  int possibleAnswersLength = 0;
  String answer = "";

  _MagicBallPageState() {
    _magicBallAnswers();
  }

  Future<void> _magicBallAnswers() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final answersList = assetManifest
        .listAssets()
        .where((path) => path.startsWith("assets/magic_ball"))
        .toList();

    setState(() {
      possibleAnswers = answersList;
      possibleAnswersLength = possibleAnswers.length;
    });
  }

  void randomAnswer() {
    int answerIndex = Random().nextInt(possibleAnswersLength);

    setState(() {
      answer = possibleAnswers[answerIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    ///Show loading page while possibleAnswers are not set
    while (possibleAnswers.isEmpty) {
      return _buildLoading();
    }

    /// once possibleAnswers are in place, select and set one random answer
    randomAnswer();

    ///pass answer: to display the appropriate 8 balls image
    ///pass randomAnswer: function which on clicks sets another answer
    return MagicLayout(answer: answer, randomAnswer: randomAnswer);
  }

  Widget _buildLoading() {
    ///Loading Page construct to display Loading while async function is doing
    /// its job
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Loading",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class MagicLayout extends StatelessWidget {
  final VoidCallback randomAnswer;
  final String answer;

  const MagicLayout(
      {required this.answer, required this.randomAnswer, super.key});

  @override
  Widget build(BuildContext context) {
    return _buildMagicBall();
  }

  Widget _buildMagicBall() {
    /// InkWell provides the onTap animation, hence the better choice
    return InkWell(
      onTap: randomAnswer,
      splashColor: Colors.lightBlue,
      child: MagicBallImage(
        imagePath: answer,
      ),
    );
  }
}

class MagicBallImage extends StatelessWidget {
  final String imagePath;
  const MagicBallImage({required this.imagePath, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}
