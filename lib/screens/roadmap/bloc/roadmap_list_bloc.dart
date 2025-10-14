
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadmap/models/roadmap_model.dart';
import 'package:roadmap/repositories/roadmap_repository.dart';

part 'roadmap_list_event.dart';
part 'roadmap_list_state.dart';

class RoadmapListBloc extends Bloc<RoadmapListEvent, RoadmapListState> {
  final RoadmapRepository _roadmapRepository;
  final String _userId;
  StreamSubscription? _roadmapsSubscription;

  RoadmapListBloc({
    required RoadmapRepository roadmapRepository,
    required String userId,
  })  : _roadmapRepository = roadmapRepository,
        _userId = userId,
        super(RoadmapListInitial()) {
    on<LoadRoadmaps>(_onLoadRoadmaps);
    on<RoadmapsUpdated>(_onRoadmapsUpdated);
    on<DeleteRoadmap>(_onDeleteRoadmap);
  }

  void _onLoadRoadmaps(LoadRoadmaps event, Emitter<RoadmapListState> emit) {
    emit(RoadmapListLoading());
    final userId = event.userId.isEmpty ? FirebaseAuth.instance.currentUser!.uid : event.userId;
    _roadmapsSubscription?.cancel();
    _roadmapsSubscription = _roadmapRepository.getRoadmaps(userId).listen(
          (roadmaps) => add(RoadmapsUpdated(roadmaps)),
          onError: (error) => emit(RoadmapListError(error.toString())),
        );
  }

  void _onRoadmapsUpdated(RoadmapsUpdated event, Emitter<RoadmapListState> emit) {
    emit(RoadmapListLoaded(event.roadmaps));
  }

  void _onDeleteRoadmap(DeleteRoadmap event, Emitter<RoadmapListState> emit) async {
    try {
      await _roadmapRepository.deleteRoadmap(_userId, event.roadmapId);
    } catch (e) {
      emit(RoadmapListError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _roadmapsSubscription?.cancel();
    return super.close();
  }
}
