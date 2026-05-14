import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_screen.dart';
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {
  String selectedLanguage = "English";
  bool loading = false;

  final List<String> languages = [
    "English",
    "Tamil",
    "Hindi",
    "Malayalam",
    "Telugu",
  ];

  Future<void> saveLanguage() async {
    try {
      setState(() => loading = true);

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'preferredLanguage': selectedLanguage,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Language saved successfully"),
        ),
      );
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const DashboardScreen(),
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
        title: const Text("Choose Language"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Select your preferred language",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...languages.map((lang) {
              return RadioListTile<String>(
                title: Text(lang),
                value: lang,
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
              );
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : saveLanguage,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}