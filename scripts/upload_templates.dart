
import 'package:cloud_firestore/cloud_firestore.dart';

// IMPORTANT: 
// Before running this script, you must set up a temporary main.dart file 
// in your project that initializes Firebase for a standalone Dart environment.
//
// 1. Create a file `scripts/firebase_config.dart` with your Firebase project's configuration.
//    You can get this from your Firebase project settings.
//
//    const FirebaseOptions firebaseOptions = FirebaseOptions(
//      apiKey: "YOUR_API_KEY",
//      authDomain: "YOUR_AUTH_DOMAIN",
//      projectId: "YOUR_PROJECT_ID",
//      storageBucket: "YOUR_STORAGE_BUCKET",
//      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
//      appId: "YOUR_APP_ID",
//    );
//
// 2. Create a main function in this script and call `Firebase.initializeApp`:
//
//    void main() async {
//      await Firebase.initializeApp(options: firebaseOptions);
//      await uploadTemplates();
//    }
//
// 3. Run this script from your terminal:
//    dart run scripts/upload_templates.dart

Future<void> uploadTemplates() async {
  final firestore = FirebaseFirestore.instance;

  final templates = [
    {
      'title': 'Full-Stack Developer Roadmap 2025',
      'description': 'A complete guide to becoming a Full-Stack Developer in 2025.',
      'milestones': [
        {'title': 'Learn HTML, CSS, and JavaScript', 'order': 0},
        {'title': 'Learn a Frontend Framework (React, Vue, or Angular)', 'order': 1},
        {'title': 'Learn a Backend Language (Node.js, Python, or Go)', 'order': 2},
      ]
    },
    {
      'title': '3-Month Fitness Plan',
      'description': 'A plan to improve your fitness over 3 months.',
      'milestones': [
        {'title': 'Month 1: Build a consistent workout routine', 'order': 0},
        {'title': 'Month 2: Increase intensity and focus on nutrition', 'order': 1},
        {'title': 'Month 3: Advanced workouts and progress tracking', 'order': 2},
      ]
    }
  ];

  for (var template in templates) {
    final templateDoc = await firestore.collection('templates').add({
      'title': template['title'],
      'description': template['description'],
      'progress': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'source': 'template',
    });

    final milestones = template['milestones'] as List<Map<String, dynamic>>;
    for (var milestone in milestones) {
      await templateDoc.collection('milestones').add({
        'title': milestone['title'],
        'order': milestone['order'],
        'status': 'not_started',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    print('Uploaded template: ${template['title']}');
  }
}

// To make this script runnable, you need a main function that initializes Firebase.
// See the instructions at the top of this file.
