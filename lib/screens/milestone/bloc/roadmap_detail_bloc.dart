
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:roadmap/models/milestone_model.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';

part 'roadmap_detail_event.dart';
part 'roadmap_detail_state.dart';

class RoadmapDetailBloc extends Bloc<RoadmapDetailEvent, RoadmapDetailState> {
  final RoadmapRepository _roadmapRepository;
  final String _userId;
  final String _roadmapId;
  StreamSubscription? _milestonesSubscription;

  RoadmapDetailBloc({
    required RoadmapRepository roadmapRepository,
    required String userId,
    required String roadmapId,
  })  : _roadmapRepository = roadmapRepository,
        _userId = userId,
        _roadmapId = roadmapId,
        super(RoadmapDetailInitial()) {
    on<LoadMilestones>(_onLoadMilestones);
    on<MilestonesUpdated>(_onMilestonesUpdated);
    on<UpdateMilestoneStatus>(_onUpdateMilestoneStatus);
    on<AddMilestone>(_onAddMilestone);
    on<DeleteMilestone>(_onDeleteMilestone);
  }

  void _onLoadMilestones(LoadMilestones event, Emitter<RoadmapDetailState> emit) {
    emit(RoadmapDetailLoading());
    _milestonesSubscription?.cancel();
    _milestonesSubscription = _roadmapRepository.getMilestones(_userId, _roadmapId).listen(
          (milestones) => add(MilestonesUpdated(milestones)),
          onError: (error) => emit(RoadmapDetailError(error.toString())),
        );
  }

  void _onMilestonesUpdated(MilestonesUpdated event, Emitter<RoadmapDetailState> emit) {
    emit(RoadmapDetailLoaded(event.milestones));
  }

  void _onUpdateMilestoneStatus(
      UpdateMilestoneStatus event, Emitter<RoadmapDetailState> emit) async {
    try {
      final updatedMilestone = event.milestone.copyWith(status: event.newStatus);
      await _roadmapRepository.updateMilestone(_userId, _roadmapId, updatedMilestone);
    } catch (e) {
      emit(RoadmapDetailError(e.toString()));
    }
  }

  void _onAddMilestone(AddMilestone event, Emitter<RoadmapDetailState> emit) async {
    try {
      final newMilestone = MilestoneModel(
        title: event.title,
        order: (state as RoadmapDetailLoaded).milestones.length,
        createdAt: Timestamp.now(),
      );
      await _roadmapRepository.addMilestone(_userId, _roadmapId, newMilestone);
    } catch (e) {
      emit(RoadmapDetailError(e.toString()));
    }
  }

  void _onDeleteMilestone(DeleteMilestone event, Emitter<RoadmapDetailState> emit) async {
    try {
      await _roadmapRepository.deleteMilestone(_userId, _roadmapId, event.milestoneId);
    } catch (e) {
      emit(RoadmapDetailError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _milestonesSubscription?.cancel();
    return super.close();
  }
}
