
part of 'roadmap_list_bloc.dart';

abstract class RoadmapListEvent extends Equatable {
  const RoadmapListEvent();

  @override
  List<Object> get props => [];
}

class LoadRoadmaps extends RoadmapListEvent {
  final String userId;

  const LoadRoadmaps(this.userId);

  @override
  List<Object> get props => [userId];
}

class RoadmapsUpdated extends RoadmapListEvent {
  final List<RoadmapModel> roadmaps;

  const RoadmapsUpdated(this.roadmaps);

  @override
  List<Object> get props => [roadmaps];
}

class DeleteRoadmap extends RoadmapListEvent {
  final String roadmapId;

  const DeleteRoadmap(this.roadmapId);

  @override
  List<Object> get props => [roadmapId];
}
