
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RoadmapModel extends Equatable {
  final String? id;
  final String title;
  final String description;
  final double progress;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String source;

  const RoadmapModel({
    this.id,
    required this.title,
    required this.description,
    this.progress = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.source,
  });

  @override
  List<Object?> get props => [id, title, description, progress, createdAt, updatedAt, source];

  RoadmapModel copyWith({
    String? id,
    String? title,
    String? description,
    double? progress,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? source,
  }) {
    return RoadmapModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      source: source ?? this.source,
    );
  }

  factory RoadmapModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RoadmapModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      progress: (data['progress'] ?? 0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      source: data['source'] ?? 'manual',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'progress': progress,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'source': source,
    };
  }
}
