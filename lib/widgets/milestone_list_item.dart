
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadmap/models/milestone_model.dart';

class MilestoneListItem extends StatelessWidget {
  final MilestoneModel milestone;
  final Function(MilestoneStatus) onStatusChanged;

  const MilestoneListItem({
    super.key,
    required this.milestone,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          milestone.title,
          style: GoogleFonts.lato(
            decoration: milestone.status == MilestoneStatus.done
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: milestone.deadline != null
            ? Text('Due: ${milestone.deadline!.toDate().toLocal().toString().split(' ')[0]}')
            : null,
        trailing: DropdownButton<MilestoneStatus>(
          value: milestone.status,
          onChanged: (MilestoneStatus? newValue) {
            if (newValue != null) {
              onStatusChanged(newValue);
            }
          },
          items: MilestoneStatus.values
              .map<DropdownMenuItem<MilestoneStatus>>((MilestoneStatus value) {
            return DropdownMenuItem<MilestoneStatus>(
              value: value,
              child: Text(value.toString().split('.').last.replaceAll('_', ' ')),
            );
          }).toList(),
        ),
      ),
    );
  }
}
