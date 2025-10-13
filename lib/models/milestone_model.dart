
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum MilestoneStatus { notStarted, inProgress, done }

class MilestoneModel extends Equatable {
  final String? id;
  final String title;
  final MilestoneStatus status;
  final Timestamp? deadline;
  final int order;
  final Timestamp createdAt;

  const MilestoneModel({
    this.id,
    required this.title,
    this.status = MilestoneStatus.notStarted,
    this.deadline,
    required this.order,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, status, deadline, order, createdAt];

  MilestoneModel copyWith({
    String? id,
    String? title,
    MilestoneStatus? status,
    Timestamp? deadline,
    int? order,
    Timestamp? createdAt,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory MilestoneModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MilestoneModel(
      id: doc.id,
      title: data['title'] ?? '',
      status: MilestoneStatus.values.firstWhere(
        (e) => e.toString() == 'MilestoneStatus.${data['status']}',
        orElse: () => MilestoneStatus.notStarted,
      ),
      deadline: data['deadline'],
      order: data['order'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'status': status.toString().split('.').last,
      'deadline': deadline,
      'order': order,
      'createdAt': createdAt,
    };
  }
}
