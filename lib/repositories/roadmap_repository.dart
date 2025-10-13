
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/milestone_model.dart';
import '../models/roadmap_model.dart';
import '../services/firestore_service.dart';

class RoadmapRepository {
  final FirestoreService _firestoreService;

  RoadmapRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // Roadmap operations
  Stream<List<RoadmapModel>> getRoadmaps(String uid) {
    return _firestoreService.getCollection<RoadmapModel>(
      path: 'users/$uid/roadmaps',
      builder: (doc) => RoadmapModel.fromFirestore(doc),
    );
  }

  Future<DocumentReference> addRoadmap(String uid, RoadmapModel roadmap) {
    return _firestoreService.addDocument(
      path: 'users/$uid/roadmaps',
      data: roadmap.toFirestore(),
    );
  }

  Future<void> updateRoadmap(String uid, RoadmapModel roadmap) {
    return _firestoreService.updateDocument(
      path: 'users/$uid/roadmaps/${roadmap.id}',
      data: roadmap.toFirestore(),
    );
  }

  Future<void> deleteRoadmap(String uid, String roadmapId) {
    return _firestoreService.deleteDocument(path: 'users/$uid/roadmaps/$roadmapId');
  }

  // Milestone operations
  Stream<List<MilestoneModel>> getMilestones(String uid, String roadmapId) {
    final path = 'users/$uid/roadmaps/$roadmapId/milestones';
    return _firestoreService.getCollection<MilestoneModel>(
      path: path,
      builder: (doc) => MilestoneModel.fromFirestore(doc),
    )..listen((milestones) => _updateRoadmapProgress(uid, roadmapId, milestones));
  }

  Future<DocumentReference> addMilestone(String uid, String roadmapId, MilestoneModel milestone) {
    return _firestoreService.addDocument(
      path: 'users/$uid/roadmaps/$roadmapId/milestones',
      data: milestone.toFirestore(),
    );
  }

  Future<void> updateMilestone(String uid, String roadmapId, MilestoneModel milestone) {
    return _firestoreService.updateDocument(
      path: 'users/$uid/roadmaps/$roadmapId/milestones/${milestone.id}',
      data: milestone.toFirestore(),
    );
  }

  Future<void> deleteMilestone(String uid, String roadmapId, String milestoneId) {
    return _firestoreService.deleteDocument(
        path: 'users/$uid/roadmaps/$roadmapId/milestones/$milestoneId');
  }

  // Progress calculation
  Future<void> _updateRoadmapProgress(String uid, String roadmapId, List<MilestoneModel> milestones) async {
    if (milestones.isEmpty) {
      await _updateProgress(uid, roadmapId, 0); 
      return;
    }
    final doneCount = milestones.where((m) => m.status == MilestoneStatus.done).length;
    final progress = doneCount / milestones.length;
    await _updateProgress(uid, roadmapId, progress);
  }
  
  Future<void> _updateProgress(String uid, String roadmapId, double progress) {
      return _firestoreService.updateDocument(
      path: 'users/$uid/roadmaps/$roadmapId',
      data: {'progress': progress, 'updatedAt': Timestamp.now()},
    );
  }

  // Template operations
  Stream<List<RoadmapModel>> getTemplates() {
    return _firestoreService.getCollection<RoadmapModel>(
      path: 'templates',
      builder: (doc) => RoadmapModel.fromFirestore(doc),
    );
  }

  Future<void> importTemplate(String uid, RoadmapModel template) async {
    // 1. Create a new roadmap from the template
    final newRoadmap = template.copyWith(
      source: 'template',
      progress: 0,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
    DocumentReference roadmapRef = await addRoadmap(uid, newRoadmap);

    // 2. Get milestones from the template
    final templateMilestones = await _firestoreService
        .getCollection<MilestoneModel>(
          path: 'templates/${template.id}/milestones',
          builder: (doc) => MilestoneModel.fromFirestore(doc),
        )
        .first; // Use .first to get a single list from the stream

    // 3. Add milestones to the new roadmap
    for (var milestone in templateMilestones) {
      final newMilestone = milestone.copyWith(
        status: MilestoneStatus.notStarted,
        createdAt: Timestamp.now(),
      );
      await addMilestone(uid, roadmapRef.id, newMilestone);
    }
  }
}
