import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  bool loading = true;

  int currentQuestion = 0;
  int score = 0;
  String? selectedAnswer;

  final Map<String, List<Map<String, dynamic>>> quizBank = {
    "Programming": [
      {
        "question": "What is OOP?",
        "options": [
          "Object Oriented Programming",
          "Only One Program",
          "Open Operation Process",
          "None"
        ],
        "answer": "Object Oriented Programming",
      },
      {
        "question": "Binary Search complexity?",
        "options": ["O(n)", "O(log n)", "O(n²)", "O(1)"],
        "answer": "O(log n)",
      },
    ],
    "AI / ML": [
      {
        "question": "What does AI stand for?",
        "options": [
          "Artificial Intelligence",
          "Automatic Input",
          "Advanced Internet",
          "None"
        ],
        "answer": "Artificial Intelligence",
      },
    ],
    "Mathematics": [
      {
        "question": "2 + 2 = ?",
        "options": ["3", "4", "5", "6"],
        "answer": "4",
      },
    ],
    "Physics": [
      {
        "question": "Force formula?",
        "options": ["F=ma", "E=mc²", "V=IR"],
        "answer": "F=ma",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  Future<void> loadQuiz() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setDefaultQuiz();
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();

      if (data == null || !data.containsKey('subjects')) {
        setDefaultQuiz();
        return;
      }

      final subjects = List<String>.from(data['subjects']);
      List<Map<String, dynamic>> loadedQuestions = [];

      for (String subject in subjects) {
        if (quizBank.containsKey(subject)) {
          loadedQuestions.addAll(quizBank[subject]!);
        }
      }

      if (loadedQuestions.isEmpty) {
        setDefaultQuiz();
        return;
      }

      setState(() {
        questions = loadedQuestions;
        loading = false;
      });
    } catch (e) {
      setDefaultQuiz();
    }
  }

  void setDefaultQuiz() {
    setState(() {
      questions = [
        {
          "question": "What does AI stand for?",
          "options": [
            "Artificial Intelligence",
            "Animal Instinct"
          ],
          "answer": "Artificial Intelligence",
        }
      ];
      loading = false;
    });
  }

  Future<void> saveQuizScore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      await userRef.collection('quiz_history').add({
        'score': score,
        'total': questions.length,
        'timestamp': Timestamp.now(),
      });

      final userDoc = await userRef.get();
      final data = userDoc.data();

      int currentXp = 0;

      if (data != null && data.containsKey('xp')) {
        currentXp = data['xp'];
      }

      await userRef.set({
        'xp': currentXp + 10,
      }, SetOptions(merge: true));

    } catch (e) {
      print(e);
    }
  }

  Future<void> nextQuestion() async {
    if (selectedAnswer == questions[currentQuestion]["answer"]) {
      score++;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      await saveQuizScore();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Quiz Complete 🎉"),
          content: Text("Your Score: $score / ${questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personalized Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestion + 1}/${questions.length}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            Text(
              question["question"],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...question["options"].map<Widget>((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value;
                  });
                },
              );
            }).toList(),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: selectedAnswer == null
                    ? null
                    : () async {
                        await nextQuestion();
                      },
                child: Text(
                  currentQuestion == questions.length - 1
                      ? "Submit"
                      : "Next",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}