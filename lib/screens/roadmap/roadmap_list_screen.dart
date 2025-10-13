
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';
import 'package:roadmap/screens/auth/bloc/auth_bloc.dart';
import 'package:roadmap/screens/roadmap/bloc/roadmap_list_bloc.dart';
import 'package:roadmap/widgets/roadmap_list_item.dart';

class RoadmapListScreen extends StatelessWidget {
  const RoadmapListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return BlocProvider(
      create: (context) => RoadmapListBloc(
        roadmapRepository: context.read<RoadmapRepository>(),
        userId: user!.uid,
      )..add(LoadRoadmaps(user.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Roadmaps'),
          actions: [
            IconButton(
              icon: const Icon(Icons.collections_bookmark),
              onPressed: () {
                context.go('/templates');
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
            ),
          ],
        ),
        body: BlocBuilder<RoadmapListBloc, RoadmapListState>(
          builder: (context, state) {
            if (state is RoadmapListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RoadmapListLoaded) {
              if (state.roadmaps.isEmpty) {
                return const Center(child: Text('No roadmaps yet. Create one!'));
              }
              return ListView.builder(
                itemCount: state.roadmaps.length,
                itemBuilder: (context, index) {
                  final roadmap = state.roadmaps[index];
                  return RoadmapListItem(
                    roadmap: roadmap,
                    onTap: () {
                      context.go('/roadmaps/${roadmap.id}', extra: roadmap);
                    },
                  );
                },
              );
            } else if (state is RoadmapListError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/create-roadmap');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
