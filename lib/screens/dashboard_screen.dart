import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ai_tutor_screen.dart';
import 'quiz_screen.dart';
import 'planner_screen.dart';
import 'profile_screen.dart';
import 'flashcards_screen.dart';
import 'leaderboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  int xp = 0;
  int quizzesTaken = 0;
  int streak = 0;
  String bestScore = "0/0";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final userDoc = await userRef.get();
    final history = await userRef.collection('quiz_history').get();

    int highest = 0;
    int highestTotal = 0;

    for (var doc in history.docs) {
      final data = doc.data();
      int score = data['score'] ?? 0;
      int total = data['total'] ?? 0;

      if (score > highest) {
        highest = score;
        highestTotal = total;
      }
    }

    setState(() {
      xp = userDoc.data()?['xp'] ?? 0;
      streak = userDoc.data()?['streak'] ?? 0;
      quizzesTaken = history.docs.length;
      bestScore = "$highest/$highestTotal";
      loading = false;
    });
  }

  Future<void> openScreen(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );

    await loadDashboardData();
  }

  Widget analyticsCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget dashboardCard(
    String title,
    IconData icon,
    Widget screen,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => openScreen(screen),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFF4F46E5),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("LearnDNA AI"),
        actions: [
          IconButton(
            onPressed: () {
              openScreen(const ProfileScreen());
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              user?.email ?? "",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            analyticsCard(
              "🔥 Daily Streak",
              "$streak Days",
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: analyticsCard("XP", "$xp"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: analyticsCard(
                    "Quizzes",
                    "$quizzesTaken",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            analyticsCard("Best Score", bestScore),

            const SizedBox(height: 30),

            Row(
              children: [
                dashboardCard(
                  "AI Tutor",
                  Icons.smart_toy,
                  const AITutorScreen(),
                ),
                const SizedBox(width: 12),
                dashboardCard(
                  "Quiz",
                  Icons.quiz,
                  const QuizScreen(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                dashboardCard(
                  "Flashcards",
                  Icons.style,
                  const FlashcardsScreen(),
                ),
                const SizedBox(width: 12),
                dashboardCard(
                  "Planner",
                  Icons.calendar_month,
                  const PlannerScreen(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                dashboardCard(
                  "Leaderboard",
                  Icons.emoji_events,
                  const LeaderboardScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}