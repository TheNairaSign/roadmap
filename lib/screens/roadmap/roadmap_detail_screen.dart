
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roadmap/models/roadmap_model.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';
import 'package:roadmap/screens/auth/bloc/auth_bloc.dart';
import 'package:roadmap/screens/milestone/bloc/roadmap_detail_bloc.dart';
import 'package:roadmap/widgets/milestone_list_item.dart';

class RoadmapDetailScreen extends StatelessWidget {
  final RoadmapModel roadmap;

  const RoadmapDetailScreen({super.key, required this.roadmap});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user!;

    return BlocProvider(
      create: (context) => RoadmapDetailBloc(
        roadmapRepository: context.read<RoadmapRepository>(),
        userId: user.uid,
        roadmapId: roadmap.id!,
      )..add(LoadMilestones()),
      child: Scaffold(
        appBar: AppBar(title: Text(roadmap.title)),
        body: BlocBuilder<RoadmapDetailBloc, RoadmapDetailState>(
          builder: (context, state) {
            if (state is RoadmapDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RoadmapDetailLoaded) {
              return ListView.builder(
                itemCount: state.milestones.length,
                itemBuilder: (context, index) {
                  final milestone = state.milestones[index];
                  return MilestoneListItem(
                    milestone: milestone,
                    onStatusChanged: (newStatus) {
                      context
                          .read<RoadmapDetailBloc>()
                          .add(UpdateMilestoneStatus(milestone, newStatus));
                    },
                  );
                },
              );
            } else if (state is RoadmapDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddMilestoneDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddMilestoneDialog(BuildContext context) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Milestone'),
          content: CustomTextField(
            controller: titleController,
            labelText: 'Title',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  context.read<RoadmapDetailBloc>().add(AddMilestone(titleController.text));
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
