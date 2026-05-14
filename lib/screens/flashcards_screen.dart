import 'package:flutter/material.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final List<Map<String, String>> flashcards = [
    {
      "question": "What is OOP?",
      "answer": "Object Oriented Programming",
    },
    {
      "question": "What is AI?",
      "answer": "Artificial Intelligence",
    },
    {
      "question": "What is CPU?",
      "answer": "Central Processing Unit",
    },
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),

            GestureDetector(
              onTap: () {
                setState(() {
                  showAnswer = !showAnswer;
                });
              },
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      showAnswer
                          ? card["answer"]!
                          : card["question"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text("Tap card to reveal answer"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: nextCard,
                child: const Text("Next Card"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
