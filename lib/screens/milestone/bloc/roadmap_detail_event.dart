
part of 'roadmap_detail_bloc.dart';

abstract class RoadmapDetailEvent extends Equatable {
  const RoadmapDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadMilestones extends RoadmapDetailEvent {}

class MilestonesUpdated extends RoadmapDetailEvent {
  final List<MilestoneModel> milestones;

  const MilestonesUpdated(this.milestones);

  @override
  List<Object> get props => [milestones];
}

class UpdateMilestoneStatus extends RoadmapDetailEvent {
  final MilestoneModel milestone;
  final MilestoneStatus newStatus;

  const UpdateMilestoneStatus(this.milestone, this.newStatus);

  @override
  List<Object> get props => [milestone, newStatus];
}

class AddMilestone extends RoadmapDetailEvent {
  final String title;

  const AddMilestone(this.title);

  @override
  List<Object> get props => [title];
}

class DeleteMilestone extends RoadmapDetailEvent {
  final String milestoneId;

  const DeleteMilestone(this.milestoneId);

  @override
  List<Object> get props => [milestoneId];
}
