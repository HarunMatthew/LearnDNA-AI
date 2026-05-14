import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'certificate_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  int quizCount = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final doc = await userRef.get();
    final history = await userRef.collection('quiz_history').get();

    setState(() {
      userData = doc.data();
      quizCount = history.docs.length;
      loading = false;
    });
  }

  Widget infoCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getBadges() {
    List<Widget> badges = [];

    int xp = userData?['xp'] ?? 0;

    if (quizCount >= 1) {
      badges.add(chip("🎯 First Quiz"));
    }

    if (xp >= 50) {
      badges.add(chip("🔥 XP Master"));
    }

    if (xp >= 100) {
      badges.add(chip("🏆 Quiz Champion"));
    }

    return badges;
  }

  Widget chip(String text) {
    return Chip(label: Text(text));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context);

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    final xp = userData?['xp'] ?? 0;
    final name = userData?['name'] ?? "";
    final email = user?.email ?? "";
    final photoUrl = userData?['photoUrl'] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage:
                    photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : null,
              ),

              const SizedBox(height: 20),

              SwitchListTile(
                title: const Text("Dark Mode 🌙"),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),

              const SizedBox(height: 20),

              infoCard("Name", name),
              infoCard("Email", email),
              infoCard("XP Points", "$xp"),

              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: getBadges(),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CertificateScreen(
                          name: name,
                          email: email,
                          xp: xp,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.workspace_premium,
                  ),
                  label: const Text(
                    "View Certificate 🎓",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}