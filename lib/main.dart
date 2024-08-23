// Try to use size.height (aka MediaQuery.of(context).size.height) for font sizes instead of width so that landscape mode works too
// Android studio emulator seems to be closer to real life devices than bluestacks emulator when it comes to screen sizes and ratios.
// Problems in Bluestacks emulator (like the multiple alert dialogs when opening the app) that are not present in Android studio emulators might still be present in real life devices.
// Remember when testing 4K screens that they would have higher dpi ~480 dpi.
// So test on all three, android studio emulator, bluestacks emulator (ignore size issues) and real life devices.
// Note: flutter uses "logical pixels" which are roughly the same size on all screens.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: MyApp(key: ValueKey("MyApp")),
      ),
    ),
  );
}

Future<void> showBrailleDialog(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  bool doNotShowAgain = prefs.getBool('do_not_show_again') ?? true;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                "How to read Braille in number form",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.035),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Braille is a system of raised dots that can be read with'
                    ' the fingers by people who are visually impaired. It is '
                    'arranged in 2 columns and 3 rows. To number Braille, you '
                    'start from the first column on the left, down to the third '
                    'row, and then start with the second column on the right and '
                    'once again down to the third row. For example: 1 corresponds '
                    'to the top-left dot and 6 corresponds to the bottom-right dot.'
                    '\n\nTo form letters, certain dots are raised. For example, '
                    'the letter "C" is represented by the two dots at the top '
                    'of both columns (1 4). The letter "P" is represented by '
                    'all the dots in the left column and the top '
                    'dot in the right column (1 2 3 4).\n\nTo help you visualize this, '
                    'here is the braille grid:\n',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.022,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '1 4\n2 5\n3 6',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                  ),
                  Text(
                    '\nBy using this numbering system, it becomes easy to learn Braille '
                    'without tactile feedback, which not everyone has access to.'
                    '\n\nYou can find this tooltip in the help button at the top right.',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.022,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04, // Adjust checkbox size
                        width: MediaQuery.of(context).size.height * 0.04,
                        child: Checkbox(
                          value: doNotShowAgain,
                          onChanged: (bool? value) {
                            setState(() {
                              doNotShowAgain = value ?? false;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03, // Adjust text size
                        child: Text(
                          'Do not show again',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.022,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ),
                    onPressed: () async {
                      if (doNotShowAgain) {
                        await prefs.setBool('do_not_show_again', true); // Save checkbox state
                      } else {
                        await prefs.setBool('do_not_show_again', false);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key key = const ValueKey("MyApp")});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), () {
      final size = MediaQuery.of(context).size;
      // delayed so widgets can be built first
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog( // use content padding (like shinkwrap in Blender) if required, but it messes up horizontal alignment. Normally this popup would be big vertically because of the big text even though there is no need.
              title: Text(
                "Accessibility for the Visually Impaired",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.035),
              ),
              content: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "This app supports accessibility services like Google "
                      "TalkBack (for Android) and VoiceOver (for iOS) that "
                      "help the visually impaired in navigating their phones. "
                      "DiffAbled works in unison with TalkBack and VoiceOver "
                      "to teach languages to the visually impaired.",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.022),
                    ),
                  ),
                  /*Center(
                    child: Text.rich(
                      TextSpan(
                        // with no TextStyle it will have default text style
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                "",
                            style: const TextStyle(),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),*/
                ],
              ),
              actions: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            0.02, // Set the font size to scale with screen width
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    });

    return Navigator(
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  MaterialPageRoute _onGenerateRoute(RouteSettings settings) {
    WidgetBuilder builder = (BuildContext context) => const Scaffold(
          body: Center(
            child: Text("Page Not Found"),
          ),
        );
    switch (settings.name) {
      case '/':
        builder = (BuildContext context) => Scaffold(
              appBar: AppBar(
                        toolbarHeight: MediaQuery.of(context).size.height *
                                0.08,
                backgroundColor: Color.fromARGB(255, 3, 100, 22),
                title: const Text('DiffAbled'),
                                actions: [
          IconButton(
            icon: Icon(Icons.help, size: MediaQuery.of(context).size.height *
                                0.037),
            tooltip: 'Help',
                    onPressed: () async {
                      showBrailleDialog(context);
                    },
          ),
        ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.1, // Set your desired height
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.0005,
                            bottom: MediaQuery.of(context).size.height * 0.025),
                        child: FloatingActionButton.extended(
                          onPressed: () async {
                            {
                              await AssetsAudioPlayer.newPlayer().open(
                                Audio("assets/audio/Bop.wav"),
                                autoStart: true,
                                showNotification: false,
                              );
                              SystemSound.play(SystemSoundType.alert);
                              Navigator.pushNamed(context, '/quiz');
                            }
                              final prefs = await SharedPreferences.getInstance();
  bool doNotShowAgain = prefs.getBool('do_not_show_again') ?? true;

  if (doNotShowAgain) return;
else showBrailleDialog(context);
                          },
                          enableFeedback: false,
                          icon: Icon(
                            Icons.quiz,
                            size: MediaQuery.of(context).size.height *
                                0.037, // Adjust the size as needed
                          ),
                          label: Text(
                            "Braille: Quiz",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height *
                                  0.037, // Increase the font size here
                              fontWeight: FontWeight
                                  .bold, // Optional: Set the font weight
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.1, // Set your desired height
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.025,
                            bottom:
                                MediaQuery.of(context).size.height * 0.0005),
                        child: FloatingActionButton.extended(
                          onPressed: () async {
                            {
                              await AssetsAudioPlayer.newPlayer().open(
                                Audio("assets/audio/Bop.wav"),
                                autoStart: true,
                                showNotification: false,
                              );
                              SystemSound.play(SystemSoundType.alert);
                              Navigator.pushNamed(context, '/study');
                            }
                              final prefs = await SharedPreferences.getInstance();
  bool doNotShowAgain = prefs.getBool('do_not_show_again') ?? true;

  if (doNotShowAgain) return;
  else showBrailleDialog(context);
                          },
                          enableFeedback: false,
                          icon: Icon(
                            Icons.library_books,
                            size: MediaQuery.of(context).size.height *
                                0.037, // Adjust the size as needed
                          ),
                          label: Text(
                            "Braille: Study",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height *
                                  0.037, // Increase the font size here
                              fontWeight: FontWeight
                                  .bold, // Optional: Set the font weight
                            ),
                          ),
                          backgroundColor: Colors.pink,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/DiffAbled Icon Compressed.png",
                      height: MediaQuery.of(context).size.height *
                          0.5, // Set the height of the image
                      fit: BoxFit
                          .contain, // Adjust the box fit to ensure proper scaling
                    ),
                  ],
                ),
              ),
            );
        break;
      case '/quiz':
        builder = (BuildContext context) => const QuizPage();
        break;
      case '/study':
        builder = (BuildContext context) => StudyPage();
        break;
    }
    return MaterialPageRoute(builder: builder, settings: settings);
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestion = 0;
  int _score = 0;
  Map<String, Object> _currentQuestionData = {};

  final List<Map<String, Object>> _brailleLetters = [
    {'letter': '⠁', 'meaning': 'a', 'number': '1'},
    {'letter': '⠃', 'meaning': 'b', 'number': '1 2'},
    {'letter': '⠉', 'meaning': 'c', 'number': '1 4'},
    {'letter': '⠙', 'meaning': 'd', 'number': '1 4 5'},
    {'letter': '⠑', 'meaning': 'e', 'number': '1 5'},
    {'letter': '⠋', 'meaning': 'f', 'number': '1 2 4'},
    {'letter': '⠛', 'meaning': 'g', 'number': '1 2 4 5'},
    {'letter': '⠓', 'meaning': 'h', 'number': '1 2 5'},
    {'letter': '⠊', 'meaning': 'i', 'number': '2 4'},
    {'letter': '⠚', 'meaning': 'j', 'number': '2 4 5'},
    {'letter': '⠅', 'meaning': 'k', 'number': '1 3'},
    {'letter': '⠇', 'meaning': 'l', 'number': '1 2 3'},
    {'letter': '⠍', 'meaning': 'm', 'number': '1 3 4'},
    {'letter': '⠝', 'meaning': 'n', 'number': '1 3 4 5'},
    {'letter': '⠕', 'meaning': 'o', 'number': '1 3 5'},
    {'letter': '⠏', 'meaning': 'p', 'number': '1 2 3 4'},
    {'letter': '⠟', 'meaning': 'q', 'number': '1 2 3 4 5'},
    {'letter': '⠗', 'meaning': 'r', 'number': '1 2 3 5'},
    {'letter': '⠎', 'meaning': 's', 'number': '2 3 4'},
    {'letter': '⠞', 'meaning': 't', 'number': '2 3 4 5'},
    {'letter': '⠥', 'meaning': 'u', 'number': '1 3 6'},
    {'letter': '⠧', 'meaning': 'v', 'number': '1 2 3 6'},
    {'letter': '⠺', 'meaning': 'w', 'number': '2 4 5 6'},
    {'letter': '⠭', 'meaning': 'x', 'number': '1 3 4 6'},
    {'letter': '⠽', 'meaning': 'y', 'number': '1 3 4 5 6'},
    {'letter': '⠵', 'meaning': 'z', 'number': '1 3 5 6'},
  ];

  @override
  void initState() {
    super.initState();
    _generateRandomQuestion();
  }

  final List<int> _usedQuestions = [];

  void _generateRandomQuestion() {
    if (_usedQuestions.length == _brailleLetters.length) {
      _usedQuestions.clear();
    }

    var random = Random();
    int randomIndex;
    do {
      randomIndex = random.nextInt(_brailleLetters.length);
    } while (_usedQuestions.contains(randomIndex));

    _usedQuestions.add(randomIndex);
    _currentQuestionData = _brailleLetters[randomIndex];

    // Create a list of all letters of the alphabet
    var allLetters = "abcdefghijklmnopqrstuvwxyz".split("");

    // Filter out the current question's letter
    var options = allLetters
        .where((letter) => letter != _currentQuestionData['meaning'])
        .toList();

    // Pick 3 random letters
    options.shuffle();
    options = options.sublist(0, 3);
    options.add(_currentQuestionData['meaning'].toString());
    options.shuffle();
    _currentQuestionData['options'] = options;
  }

  void _answerQuestion(int score, option, OptionMeaning) {
    String PopHeading = "Error: Not Found";
    if (score == 0) {
      PopHeading = "Incorrect Answer";

      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/audio/Incorrect.wav"),
        autoStart: true,
        showNotification: false,
      );
      SystemSound.play(SystemSoundType.alert);
    } else {
      PopHeading = "Correct Answer";
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/audio/Correct.wav"),
        autoStart: true,
        showNotification: false,
      );
      SystemSound.play(SystemSoundType.alert);
    }
    _score += score;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog( // use content padding (like shinkwrap in Blender) if required, but it messes up horizontal alignment. Normally this popup would be big vertically because of the big text even though there is no need.
            title: Text(
              PopHeading, // Replace with your actual text or variable
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    0.037, // Adjust multiplier as needed
              ),
              textAlign: TextAlign.center,
            ),
            content: Center(
              child: Text.rich(
                TextSpan(
                  // with no TextStyle it will have default text style
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.035),
                  children: <TextSpan>[
                    TextSpan(
                      text: _currentQuestionData['letter'].toString() + "\n",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.27,
                        fontFamily: 'AppleBraille',
                      ),
                    ),
                    TextSpan(
                      text: '"' + _currentQuestionData['number'].toString() + '"',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' stands for "'),
                    TextSpan(
                      text: _currentQuestionData['meaning'].toString() + '"',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (score == 0)
                      ...[
                        const TextSpan(text: '''


While your option "'''),
                        TextSpan(
                          text: option.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: '" stands for "'),
                        TextSpan(
                          text: OptionMeaning['number'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: '"'),
                      ],
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            actions: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          0.02, // Set the font size to scale with screen width
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _currentQuestion = _currentQuestion + 1;
                      _generateRandomQuestion();
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height *
                                0.08,
        backgroundColor: Colors.blue,
        title: const Text("Quiz"),
                actions: [
          IconButton(
            icon: Icon(Icons.help, size: MediaQuery.of(context).size.height *
                                0.037),
            tooltip: 'Help',
                    onPressed: () async {
                      showBrailleDialog(context);
                    },
          ),
        ],
      ),
      body: _currentQuestion < _brailleLetters.length
          ? Quiz(
              questionData: _currentQuestionData,
              answerQuestion: _answerQuestion,
              currentQuestion: _currentQuestion,
              score: _score,
              brailleLetters: _brailleLetters,
              resetQuiz: () {
                _resetQuiz();
              },
            )
          : ResultPage(_score, _resetQuiz),
    );
  }
}

class ResultPage extends StatelessWidget {
  // creating a new ResultPage class that takes two arguments, score and resetQuiz, as properties in the constructor.
  final int score;
  final Function
      resetQuiz; // resetQuiz is being passed as an argument to the ResultPage class from where it was defined in QuizPage

  const ResultPage(this.score, this.resetQuiz, {super.key});

  @override
  Widget build(BuildContext context) {
    int scorediff = 26 - score;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.02,
                  left: MediaQuery.of(context).size.width * 0.02,
                  bottom: MediaQuery.of(context).size.height * 0.03),
              child: Text.rich(
                TextSpan(
                  text: score == 26
                      ? '''Amazing! You got a perfect score! You can now read braille.
Your score is '''
                      : (score >= 22 && score <= 25
                          ? '''So close! You almost got a perfect score! Just $scorediff more!
Your score is '''
                          : (score < 13
                              ? '''You didn't do too well; better luck next time.
Your score is '''
                              : '''You did well, but can you do better?
Your score is ''')),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.04),
                  children: <TextSpan>[
                    TextSpan(
                      text: "$score out of 26",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                  double.infinity,
                  MediaQuery.of(context).size.height *
                      0.065), // Make button match container size
              backgroundColor: Colors
                  .green, // Match the button's color to the container's color
            ),
            onPressed: () {
              Navigator.of(context).pop();
              resetQuiz(); // Ensure to call the function with ()
            },
            child: Text(
              "Back",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  final Map<String, Object> questionData;
  final Function answerQuestion;
  final int currentQuestion;
  final int score;
  final void Function() resetQuiz;
  final brailleLetters;

  const Quiz(
      {super.key,
      required this.questionData,
      required this.answerQuestion,
      required this.currentQuestion,
      required this.score,
      required this.resetQuiz,
      required this.brailleLetters});

  Map<String, Object>? getBrailleLetterByMeaning(String meaning) {
    for (var item in brailleLetters) {
      if (item['meaning'] == meaning) {
        return item;
      }
    }
    return null; // Return null if no matching item is found
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            questionData['letter'].toString(),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.27,
                fontFamily: 'AppleBraille'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.01),
          child: Center(
            child: Text(
              "Which letter do these numbers correspond to?\n" +
                  questionData['number'].toString(),
              style: TextStyle(fontSize: size.height * 0.03),
              textAlign: TextAlign.center,
            ), // Display the current question letter
          ),
        ),
        ...(questionData['options'] as List<String>).map(
          (option) =>

// Display the options for the current question
              Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.01, bottom: size.height * 0.01),
            child: Container(
              height: size.height * 0.05,
              width: size.width *
                  0.6, // Set the width to fill the available horizontal space
              child: ElevatedButton(
                child: Text(
                  option,
                  style: TextStyle(fontSize: size.height * 0.03),
                ),
                onPressed: () {
                  if (option == questionData['meaning']) {
                    answerQuestion(
                        1, option, getBrailleLetterByMeaning(option));
                  } else {
                    answerQuestion(
                        0, option, getBrailleLetterByMeaning(option));
                  }
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.height * 0.006, bottom: size.height * 0.0035),
          child: Center(
              child: Text.rich(
            TextSpan(
              // with no TextStyle it will have default text style
              text: "Score: ",
              style: TextStyle(fontSize: size.height * 0.03),
              children: <TextSpan>[
                TextSpan(
                    text: "$score",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.height * 0.006, bottom: size.height * 0.006),
          child: Center(
            child: Text.rich(
              TextSpan(
                // with no TextStyle it will have default text style
                text: "Question ",
                style: TextStyle(fontSize: size.height * 0.03),
                children: <TextSpan>[
                  TextSpan(
                      text: "$currentQuestion",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: " of "),
                  TextSpan(
                      text: "${brailleLetters.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                  double.infinity,
                  MediaQuery.of(context).size.height *
                      0.045), // Make button match container size
              backgroundColor: Colors
                  .red, // Match the button's color to the container's color
            ),
            onPressed: resetQuiz,
            child: Text(
              "Reset Quiz",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StudyPage extends StatelessWidget {
  final List<Map<String, Object>> _brailleLetters = [
    {'letter': '⠁', 'meaning': 'A', 'number': '1'},
    {'letter': '⠃', 'meaning': 'B', 'number': '1 2'},
    {'letter': '⠉', 'meaning': 'C', 'number': '1 4'},
    {'letter': '⠙', 'meaning': 'D', 'number': '1 4 5'},
    {'letter': '⠑', 'meaning': 'E', 'number': '1 5'},
    {'letter': '⠋', 'meaning': 'F', 'number': '1 2 4'},
    {'letter': '⠛', 'meaning': 'G', 'number': '1 2 4 5'},
    {'letter': '⠓', 'meaning': 'H', 'number': '1 2 5'},
    {'letter': '⠊', 'meaning': 'I', 'number': '2 4'},
    {'letter': '⠚', 'meaning': 'J', 'number': '2 4 5'},
    {'letter': '⠅', 'meaning': 'K', 'number': '1 3'},
    {'letter': '⠇', 'meaning': 'L', 'number': '1 2 3'},
    {'letter': '⠍', 'meaning': 'M', 'number': '1 3 4'},
    {'letter': '⠝', 'meaning': 'N', 'number': '1 3 4 5'},
    {'letter': '⠕', 'meaning': 'O', 'number': '1 3 5'},
    {'letter': '⠏', 'meaning': 'P', 'number': '1 2 3 4'},
    {'letter': '⠟', 'meaning': 'Q', 'number': '1 2 3 4 5'},
    {'letter': '⠗', 'meaning': 'R', 'number': '1 2 3 5'},
    {'letter': '⠎', 'meaning': 'S', 'number': '2 3 4'},
    {'letter': '⠞', 'meaning': 'T', 'number': '2 3 4 5'},
    {'letter': '⠥', 'meaning': 'U', 'number': '1 3 6'},
    {'letter': '⠧', 'meaning': 'V', 'number': '1 2 3 6'},
    {'letter': '⠺', 'meaning': 'W', 'number': '2 4 5 6'},
    {'letter': '⠭', 'meaning': 'X', 'number': '1 3 4 6'},
    {'letter': '⠽', 'meaning': 'Y', 'number': '1 3 4 5 6'},
    {'letter': '⠵', 'meaning': 'Z', 'number': '1 3 5 6'},
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate the crossAxisCount based on the width
    // so wider devices would get more columns per row because their width would be more
    // Ensure it's at least 1 to avoid having 0 columns
    int crossAxisCount = (MediaQuery.of(context).size.width * 0.0051).toInt().clamp(
        1,
        4); // divide by device pixel ratio if 4K devices with high dpi prove to be a problem in the future
    return Scaffold(
      appBar: AppBar(
                toolbarHeight: MediaQuery.of(context).size.height *
                                0.08,
        backgroundColor: Colors.pink,
        title: const Text("Study"),
                        actions: [
          IconButton(
            icon: Icon(Icons.help, size: MediaQuery.of(context).size.height *
                                0.037),
            tooltip: 'Help',
                    onPressed: () async {
                      showBrailleDialog(context);
                    },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing:
              MediaQuery.of(context).size.height * 0.003 / crossAxisCount,
          crossAxisSpacing:
              MediaQuery.of(context).size.height * 0.003 / crossAxisCount,
          childAspectRatio: 1,
        ),
        itemCount: _brailleLetters.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.002 / crossAxisCount),
            child: Card(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Text(
                          _brailleLetters[index]['letter'].toString(),
                          style: TextStyle(
                            fontSize: constraints.maxHeight *
                                1, // Scale the font size relative to available height
                            fontFamily: 'AppleBraille',
                          ),
                          textAlign:
                              TextAlign.center, // Center the text if needed
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height *
                        0.005 /
                        crossAxisCount,
                  ),
                  child: Text(
                    _brailleLetters[index]['meaning'].toString(),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.1 /
                          crossAxisCount,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height *
                        0.025 /
                        crossAxisCount,
                  ),
                  child: Text(
                    _brailleLetters[index]['number'].toString(),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.1 /
                          crossAxisCount,
                    ),
                  ),
                ),
              ],
            )),
          );
        },
      ),
    );
  }
}
