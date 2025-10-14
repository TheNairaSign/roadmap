import 'package:flutter/material.dart';
import 'package:roadmap/screens/roadmap_display.dart';

class PhaseDetailScreen extends StatefulWidget {
  final RoadmapPhase phase;

  const PhaseDetailScreen({super.key, required this.phase});

  @override
  State<PhaseDetailScreen> createState() => _PhaseDetailScreenState();
}

class _PhaseDetailScreenState extends State<PhaseDetailScreen> {
  void _toggleCompletion(SubDetail subDetail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Completion'),
        content: Text('Do you want to mark this task as ${subDetail.isCompleted ? 'incomplete' : 'complete'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                subDetail.isCompleted = !subDetail.isCompleted;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Color _getDetailColor(RoadmapDetail detail) {
    final completedCount = detail.subDetails.where((sd) => sd.isCompleted).length;
    final percentage = completedCount / detail.subDetails.length;

    if (percentage == 1) {
      return Colors.green;
    } else if (percentage >= 0.7) {
      return Colors.yellow;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.phase.phase, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildDetailsPanel(),
      ),
    );
  }

  Widget _buildDetailsPanel() {
    return Stack(
      children: [
        Positioned(
          left: 8,
          top: 0,
          bottom: 0,
          child: Container(width: 1, color: Colors.grey.shade800),
        ),
        ListView.builder(
          itemCount: widget.phase.details.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      border: Border.all(color: Colors.grey.shade800, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.phase.title,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: CustomPaint(
                      size: const Size(40, 40),
                      painter: DottedArrowPainter(),
                    ),
                  ),
                ],
              );
            }

            final detail = widget.phase.details[index - 1];
            final color = _getDetailColor(detail);
            return Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: detail.subDetails.every((sd) => sd.isCompleted) ? Colors.green.withValues(alpha: 0.1) : Colors.transparent,
                        border: Border.all(color: Colors.grey.shade800),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.title,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...detail.subDetails.map((subDetail) => InkWell(
                                onTap: () => _toggleCompletion(subDetail),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8, left: 16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Icon(
                                          subDetail.isCompleted ? Icons.check_circle : Icons.circle,
                                          size: 12,
                                          color: subDetail.isCompleted ? Colors.green : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          subDetail.text,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: subDetail.isCompleted ? Colors.grey.shade600 : Colors.grey.shade400,
                                            height: 1.5,
                                            decoration: subDetail.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class DottedArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 4;
    const double dashSpace = 4;
    double startY = 0;
    while (startY < 40) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    final path = Path();
    path.moveTo(-5, 35);
    path.lineTo(0, 40);
    path.lineTo(5, 35);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
