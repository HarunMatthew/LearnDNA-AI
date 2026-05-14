import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class AITutorScreen extends StatefulWidget {
  const AITutorScreen({super.key});

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  final TextEditingController messageController = TextEditingController();

  String aiResponse = "";
  bool loading = false;

  Future<void> askAI() async {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      loading = true;
      aiResponse = "";
    });

    final response =
        await GeminiService.askAI(messageController.text.trim());

    setState(() {
      aiResponse = response;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Tutor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Ask your doubt here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : askAI,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Ask AI"),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    aiResponse.isEmpty
                        ? "AI response will appear here..."
                        : aiResponse,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}