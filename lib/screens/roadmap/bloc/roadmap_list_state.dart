
part of 'roadmap_list_bloc.dart';

abstract class RoadmapListState extends Equatable {
  const RoadmapListState();

  @override
  List<Object> get props => [];
}

class RoadmapListInitial extends RoadmapListState {}

class RoadmapListLoading extends RoadmapListState {}

class RoadmapListLoaded extends RoadmapListState {
  final List<RoadmapModel> roadmaps;

  const RoadmapListLoaded(this.roadmaps);

  @override
  List<Object> get props => [roadmaps];
}

class RoadmapListError extends RoadmapListState {
  final String message;

  const RoadmapListError(this.message);

  @override
  List<Object> get props => [message];
}
