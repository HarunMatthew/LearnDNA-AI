import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
    List<String> subjects = [];
String studyHours = "4";
bool loading = true;
    @override
void initState() {
  super.initState();
  loadPlannerData();
}

Future<void> loadPlannerData() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  final data = doc.data();

  if (data != null) {
    setState(() {
      subjects = List<String>.from(data['subjects'] ?? []);
      studyHours = data['studyHours'] ?? "4";
      loading = false;
    });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Planner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
           ...subjects.asMap().entries.map((entry) {
  int index = entry.key;
  String subject = entry.value;

  List<String> times = [
    "9:00 AM - 10:00 AM",
    "11:00 AM - 12:00 PM",
    "2:00 PM - 3:00 PM",
    "6:00 PM - 7:00 PM",
  ];

  return plannerCard(
    times[index % times.length],
    subject,
  );
}).toList(),
          ],
        ),
      ),
    );
  }

  Widget plannerCard(String time, String subject) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subject,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}