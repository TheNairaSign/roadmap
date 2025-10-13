
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadmap/models/roadmap_model.dart';

class RoadmapListItem extends StatelessWidget {
  final RoadmapModel roadmap;
  final VoidCallback onTap;

  const RoadmapListItem({super.key, required this.roadmap, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: onTap,
        title: Text(
          roadmap.title,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(roadmap.description),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: roadmap.progress,
              backgroundColor: Colors.grey[300],
            ),
          ],
        ),
        trailing: Text('${(roadmap.progress * 100).toInt()}%'),
      ),
    );
  }
}
