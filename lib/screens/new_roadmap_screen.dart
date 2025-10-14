import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roadmap/models/milestone_model.dart';
import 'package:roadmap/models/roadmap_model.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';
import 'package:roadmap/screens/auth/bloc/auth_bloc.dart';

class NewRoadmapScreen extends StatefulWidget {
  const NewRoadmapScreen({super.key});

  @override
  State<NewRoadmapScreen> createState() => _NewRoadmapScreenState();
}

class _NewRoadmapScreenState extends State<NewRoadmapScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<TextEditingController> _milestoneControllers = [];

  @override
  void initState() {
    super.initState();
    // Start with one milestone field
    _addMilestoneField();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _milestoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addMilestoneField() {
    setState(() {
      _milestoneControllers.add(TextEditingController());
    });
  }

  void _removeMilestoneField(int index) {
    setState(() {
      _milestoneControllers[index].dispose();
      _milestoneControllers.removeAt(index);
    });
  }

  Future<void> _saveRoadmap() async {
    if (_formKey.currentState!.validate()) {
      final user = context.read<AuthBloc>().state.user;
      if (user == null) {
        // Handle user not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to create a roadmap.')),
        );
        return;
      }

      final roadmapRepo = context.read<RoadmapRepository>();

      // Create the roadmap
      final newRoadmap = RoadmapModel(
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        source: 'manual',
      );

      try {
        final roadmapRef = await roadmapRepo.addRoadmap(user.uid, newRoadmap);

        // Create the milestones
        for (int i = 0; i < _milestoneControllers.length; i++) {
          final title = _milestoneControllers[i].text;
          if (title.isNotEmpty) {
            final newMilestone = MilestoneModel(
              title: title,
              order: i,
              createdAt: Timestamp.now(),
            );
            await roadmapRepo.addMilestone(user.uid, roadmapRef.id, newMilestone);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Roadmap created successfully!')),
        );
        context.pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create roadmap: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Roadmap'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Roadmap Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Roadmap Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Milestones',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ..._buildMilestoneFields(),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _addMilestoneField,
                icon: const Icon(Icons.add),
                label: const Text('Add Milestone'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveRoadmap,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Create Roadmap'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMilestoneFields() {
    return List.generate(_milestoneControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _milestoneControllers[index],
                decoration: InputDecoration(
                  labelText: 'Milestone ${index + 1}',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  // Allow empty milestones, they will be ignored on save
                  return null;
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => _removeMilestoneField(index),
            ),
          ],
        ),
      );
    });
  }
}