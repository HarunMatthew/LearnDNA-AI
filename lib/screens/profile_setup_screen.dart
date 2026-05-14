import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'subject_selection_screen.dart';
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final ageController = TextEditingController();
  final collegeController = TextEditingController();
  final yearController = TextEditingController();
  final goalController = TextEditingController();
  final studyHoursController = TextEditingController();

  bool loading = false;

  Future<void> saveProfile() async {
    try {
      setState(() => loading = true);

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'uid': user.uid,
        'email': user.email,
        'age': ageController.text.trim(),
        'college': collegeController.text.trim(),
        'year': yearController.text.trim(),
        'goal': goalController.text.trim(),
        'studyHours': studyHoursController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully")),
      );
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const SubjectSelectionScreen(),
  ),
);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => loading = false);
  }

  Widget customField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Profile Setup"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            customField(ageController, "Age", Icons.cake),
            customField(collegeController, "School / College", Icons.school),
            customField(yearController, "Class / Year", Icons.menu_book),
            customField(goalController, "Learning Goal", Icons.flag),
            customField(
              studyHoursController,
              "Daily Study Hours",
              Icons.access_time,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : saveProfile,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Save Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}