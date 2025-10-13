
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roadmap/models/roadmap_model.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';
import 'package:roadmap/screens/auth/bloc/auth_bloc.dart';
import 'package:roadmap/widgets/custom_textfield.dart';

import 'package:go_router/go_router.dart';

class CreateRoadmapScreen extends StatefulWidget {
  const CreateRoadmapScreen({super.key});

  @override
  State<CreateRoadmapScreen> createState() => _CreateRoadmapScreenState();
}

class _CreateRoadmapScreenState extends State<CreateRoadmapScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Roadmap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: 'Title',
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Description',
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = context.read<AuthBloc>().state.user!;
                    final roadmap = RoadmapModel(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      createdAt: Timestamp.now(),
                      updatedAt: Timestamp.now(),
                      source: 'manual',
                    );
                    context.read<RoadmapRepository>().addRoadmap(user.uid, roadmap);
                    context.pop();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
