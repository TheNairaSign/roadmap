import 'package:flutter/material.dart';
import 'package:roadmap/screens/phase_detail_screen.dart';

class SubDetail {
  final String text;
  bool isCompleted;

  SubDetail({required this.text, this.isCompleted = false});
}

class RoadmapDetail {
  final String title;
  final List<SubDetail> subDetails;

  RoadmapDetail({required this.title, required this.subDetails});
}

class RoadmapPhase {
  final String phase;
  final String title;
  final List<RoadmapDetail> details;

  RoadmapPhase({
    required this.phase,
    required this.title,
    required this.details,
  });
}

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({Key? key}) : super(key: key);

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  final List<RoadmapPhase> phases = [
    RoadmapPhase(
      phase: 'Phase 1',
      title: 'Foundation & Basics',
      details: [
        RoadmapDetail(
          title: 'Learn a Programming Language',
          subDetails: [
            SubDetail(text: 'Choose a language like Python, JavaScript, or Java.'),
            SubDetail(text: 'Understand variables, data types, and control structures.'),
            SubDetail(text: 'Practice with simple projects.'),
          ],
        ),
        RoadmapDetail(
          title: 'Understand Core CS Concepts',
          subDetails: [
            SubDetail(text: 'Data Structures (Arrays, Trees, Graphs).'),
            SubDetail(text: 'Algorithms (Sorting, Searching).'),
            SubDetail(text: 'Object-Oriented Programming (OOP) principles.'),
          ],
        ),
      ],
    ),
    RoadmapPhase(
      phase: 'Phase 2',
      title: 'Intermediate Skills',
      details: [
        RoadmapDetail(
          title: 'Version Control with Git',
          subDetails: [
            SubDetail(text: 'Learn basic commands: commit, push, pull, branch.'),
            SubDetail(text: 'Understand branching and merging strategies.'),
            SubDetail(text: 'Host your projects on GitHub or GitLab.'),
          ],
        ),
        RoadmapDetail(
          title: 'Build Tools & Package Managers',
          subDetails: [
            SubDetail(text: 'Learn to use tools like npm, Maven, or pip.'),
            SubDetail(text: 'Understand dependency management.'),
          ],
        ),
      ],
    ),
    RoadmapPhase(
      phase: 'Phase 3',
      title: 'Advanced Topics',
      details: [
        RoadmapDetail(
          title: 'Databases',
          subDetails: [
            SubDetail(text: 'Learn SQL for relational databases (e.g., PostgreSQL).'),
            SubDetail(text: 'Explore NoSQL databases (e.g., MongoDB).'),
          ],
        ),
        RoadmapDetail(
          title: 'APIs & Backend Communication',
          subDetails: [
            SubDetail(text: 'Understand RESTful APIs.'),
            SubDetail(text: 'Learn to fetch data from a backend.'),
          ],
        ),
      ],
    ),
    RoadmapPhase(
      phase: 'Phase 4',
      title: 'Specialization & Deployment',
      details: [
        RoadmapDetail(
          title: 'Choose a Specialization',
          subDetails: [
            SubDetail(text: 'Frontend (React, Vue, Angular).'),
            SubDetail(text: 'Backend (Node.js, Django, Spring).'),
            SubDetail(text: 'Mobile (Flutter, React Native).'),
          ],
        ),
        RoadmapDetail(
          title: 'Deployment & DevOps',
          subDetails: [
            SubDetail(text: 'Learn to deploy applications on platforms like AWS, Azure, or Heroku.'),
            SubDetail(text: 'Understand CI/CD pipelines.'),
          ],
        ),
      ],
    ),
  ];

  void _onPhaseTap(int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PhaseDetailScreen(phase: phases[index]),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = const Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.ease;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Roadmap',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: phases.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildPhaseCard(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseCard(int index) {
    final phase = phases[index];

    return GestureDetector(
      onTap: () => _onPhaseTap(index),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade800,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phase.phase,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    phase.title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}