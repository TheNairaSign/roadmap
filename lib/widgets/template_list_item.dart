
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadmap/models/roadmap_model.dart';

class TemplateListItem extends StatelessWidget {
  final RoadmapModel template;
  final VoidCallback onImport;

  const TemplateListItem({super.key, required this.template, required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          template.title,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(template.description),
        trailing: ElevatedButton(
          onPressed: onImport,
          child: const Text('Import'),
        ),
      ),
    );
  }
}
