
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';
import 'package:roadmap/screens/auth/bloc/auth_bloc.dart';
import 'package:roadmap/screens/roadmap/bloc/template_bloc.dart';
import 'package:roadmap/widgets/template_list_item.dart';

import 'package:go_router/go_router.dart';

class TemplateSelectionScreen extends StatelessWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user!;

    return BlocProvider(
      create: (context) => TemplateBloc(
        roadmapRepository: context.read<RoadmapRepository>(),
        userId: user.uid,
      )..add(LoadTemplates()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Import a Template')),
        body: BlocConsumer<TemplateBloc, TemplateState>(
          listener: (context, state) {
            if (state is TemplateImported) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Template imported!')));
              context.pop();
            } else if (state is TemplateError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is TemplateLoading || state is TemplateImporting) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TemplateLoaded) {
              return ListView.builder(
                itemCount: state.templates.length,
                itemBuilder: (context, index) {
                  final template = state.templates[index];
                  return TemplateListItem(
                    template: template,
                    onImport: () {
                      context.read<TemplateBloc>().add(ImportTemplate(template));
                    },
                  );
                },
              );
            } else if (state is TemplateError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        ),
      ),
    );
  }
}
