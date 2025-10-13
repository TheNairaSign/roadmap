
part of 'roadmap_detail_bloc.dart';

abstract class RoadmapDetailState extends Equatable {
  const RoadmapDetailState();

  @override
  List<Object> get props => [];
}

class RoadmapDetailInitial extends RoadmapDetailState {}

class RoadmapDetailLoading extends RoadmapDetailState {}

class RoadmapDetailLoaded extends RoadmapDetailState {
  final List<MilestoneModel> milestones;

  const RoadmapDetailLoaded(this.milestones);

  @override
  List<Object> get props => [milestones];
}

class RoadmapDetailError extends RoadmapDetailState {
  final String message;

  const RoadmapDetailError(this.message);

  @override
  List<Object> get props => [message];
}
