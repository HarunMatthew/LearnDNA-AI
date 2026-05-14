import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'language_selection_screen.dart';
class SubjectSelectionScreen extends StatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  State<SubjectSelectionScreen> createState() =>
      _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState
    extends State<SubjectSelectionScreen> {
  final List<String> subjects = [
    "Mathematics",
    "Physics",
    "Chemistry",
    "Biology",
    "Computer Science",
    "Programming",
    "Aptitude",
    "AI / ML",
  ];

  final List<String> selectedSubjects = [];
  bool loading = false;

  void toggleSubject(String subject) {
    setState(() {
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
      } else {
        selectedSubjects.add(subject);
      }
    });
  }

  Future<void> saveSubjects() async {
    try {
      setState(() => loading = true);

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'subjects': selectedSubjects,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subjects saved successfully"),
        ),
      );
    Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const LanguageSelectionScreen(),
  ),
);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Choose Subjects"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Select your learning interests",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: subjects.map((subject) {
                  final selected =
                      selectedSubjects.contains(subject);

                  return FilterChip(
                    label: Text(subject),
                    selected: selected,
                    onSelected: (_) => toggleSubject(subject),
                  );
                }).toList(),
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : saveSubjects,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Save Subjects"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}