import 'package:flutter/material.dart';
import 'dart:math' as math;


class IsometricSteps3D extends StatefulWidget {
  const IsometricSteps3D({Key? key}) : super(key: key);

  @override
  State<IsometricSteps3D> createState() => _IsometricSteps3DState();
}

class _IsometricSteps3DState extends State<IsometricSteps3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _rotationY = 0.4;
  double _rotationX = -0.3;

  final List<StepData> steps = [
    StepData(
      number: '01',
      title: 'Options',
      description: 'Lorem ipsum dolor sit amet consectetur adipiscing elit',
      icon: Icons.settings,
    ),
    StepData(
      number: '02',
      title: 'Service',
      description: 'Lorem ipsum dolor sit amet consectetur adipiscing elit',
      icon: Icons.room_service,
    ),
    StepData(
      number: '03',
      title: 'Security',
      description: 'Lorem ipsum dolor sit amet consectetur adipiscing elit',
      icon: Icons.lock,
    ),
    StepData(
      number: '04',
      title: 'Statistics',
      description: 'Lorem ipsum dolor sit amet consectetur adipiscing elit',
      icon: Icons.bar_chart,
    ),
    StepData(
      number: '05',
      title: 'Connection',
      description: 'Lorem ipsum dolor sit amet consectetur adipiscing elit',
      icon: Icons.share,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _rotationY += details.delta.dx * 0.01;
            _rotationX += details.delta.dy * 0.01;
            _rotationX = _rotationX.clamp(-math.pi / 2, 0);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3D0066),
                Color(0xFF5A0099),
                Color(0xFF7B1FA2),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        '3D Process Steps',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Drag to rotate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: IsometricStairsPainter(
                          steps: steps,
                          rotationX: _rotationX,
                          rotationY: _rotationY,
                          progress: _controller.value,
                        ),
                        size: Size.infinite,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'designed with Flutter',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IsometricStairsPainter extends CustomPainter {
  final List<StepData> steps;
  final double rotationX;
  final double rotationY;
  final double progress;

  IsometricStairsPainter({
    required this.steps,
    required this.rotationX,
    required this.rotationY,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Draw each step
    for (int i = 0; i < steps.length; i++) {
      double stepProgress = ((progress - (i * 0.15)) / 0.85).clamp(0.0, 1.0);
      if (stepProgress > 0) {
        _drawStep(canvas, i, steps[i], stepProgress);
      }
    }

    canvas.restore();
  }

  void _drawStep(Canvas canvas, int index, StepData step, double progress) {
    // Step dimensions
    final double stepWidth = 200;
    final double stepHeight = 80;
    final double stepDepth = 40;
    final double spacing = 100;

    // Position in 3D space
    final double x = index * spacing;
    final double y = -index * spacing * 0.5;
    final double z = index * spacing * 0.3;

    // Apply 3D transformations
    final vertices = _create3DBox(x, y, z, stepWidth, stepHeight, stepDepth);
    final projected = _projectVertices(vertices);

    // Draw the 3D box
    _draw3DBox(canvas, projected, step, progress);
    
    // Draw icon connector
    _drawIconConnector(canvas, index, projected, step, progress);
  }

  List<Vector3> _create3DBox(
      double x, double y, double z, double width, double height, double depth) {
    return [
      Vector3(x - width / 2, y - height / 2, z - depth / 2), // 0: front bottom left
      Vector3(x + width / 2, y - height / 2, z - depth / 2), // 1: front bottom right
      Vector3(x + width / 2, y + height / 2, z - depth / 2), // 2: front top right
      Vector3(x - width / 2, y + height / 2, z - depth / 2), // 3: front top left
      Vector3(x - width / 2, y - height / 2, z + depth / 2), // 4: back bottom left
      Vector3(x + width / 2, y - height / 2, z + depth / 2), // 5: back bottom right
      Vector3(x + width / 2, y + height / 2, z + depth / 2), // 6: back top right
      Vector3(x - width / 2, y + height / 2, z + depth / 2), // 7: back top left
    ];
  }

  List<Offset> _projectVertices(List<Vector3> vertices) {
    return vertices.map((v) {
      // Rotate around Y axis
      double cosY = math.cos(rotationY);
      double sinY = math.sin(rotationY);
      double x1 = v.x * cosY - v.z * sinY;
      double z1 = v.x * sinY + v.z * cosY;

      // Rotate around X axis
      double cosX = math.cos(rotationX);
      double sinX = math.sin(rotationX);
      double y1 = v.y * cosX - z1 * sinX;
      double z2 = v.y * sinX + z1 * cosX;

      // Perspective projection
      double perspective = 1000 / (1000 + z2);
      return Offset(x1 * perspective, y1 * perspective);
    }).toList();
  }

  void _draw3DBox(Canvas canvas, List<Offset> projected, StepData step, double progress) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Determine visible faces based on rotation
    bool frontVisible = math.cos(rotationY) > 0;
    bool topVisible = math.sin(rotationX) < 0;
    bool rightVisible = math.sin(rotationY) > 0;

    // Draw faces in correct order (back to front)
    if (!frontVisible) _drawFrontFace(canvas, projected, paint, step, progress);
    if (!rightVisible) _drawRightFace(canvas, projected, paint, progress);
    if (!topVisible) _drawTopFace(canvas, projected, paint, progress);
    
    if (topVisible) _drawTopFace(canvas, projected, paint, progress);
    if (rightVisible) _drawRightFace(canvas, projected, paint, progress);
    if (frontVisible) _drawFrontFace(canvas, projected, paint, step, progress);

    // Draw edges
    _drawEdges(canvas, projected, progress);
  }

  void _drawFrontFace(Canvas canvas, List<Offset> projected, Paint paint, StepData step, double progress) {
    final path = Path()
      ..moveTo(projected[0].dx, projected[0].dy)
      ..lineTo(projected[1].dx, projected[1].dy)
      ..lineTo(projected[2].dx, projected[2].dy)
      ..lineTo(projected[3].dx, projected[3].dy)
      ..close();

    // Main face color
    paint.color = Color.lerp(Colors.white.withOpacity(0), Colors.white, progress)!;
    canvas.drawPath(path, paint);

    // Draw text content on front face
    if (progress > 0.7) {
      _drawTextOnFace(canvas, projected, step, progress);
    }
  }

  void _drawTopFace(Canvas canvas, List<Offset> projected, Paint paint, double progress) {
    final path = Path()
      ..moveTo(projected[3].dx, projected[3].dy)
      ..lineTo(projected[2].dx, projected[2].dy)
      ..lineTo(projected[6].dx, projected[6].dy)
      ..lineTo(projected[7].dx, projected[7].dy)
      ..close();

    paint.color = Color.lerp(
      Color(0xFFE1BEE7).withOpacity(0),
      Color(0xFFE1BEE7),
      progress,
    )!;
    canvas.drawPath(path, paint);
  }

  void _drawRightFace(Canvas canvas, List<Offset> projected, Paint paint, double progress) {
    final path = Path()
      ..moveTo(projected[1].dx, projected[1].dy)
      ..lineTo(projected[5].dx, projected[5].dy)
      ..lineTo(projected[6].dx, projected[6].dy)
      ..lineTo(projected[2].dx, projected[2].dy)
      ..close();

    paint.color = Color.lerp(
      Color(0xFFCE93D8).withOpacity(0),
      Color(0xFFCE93D8),
      progress,
    )!;
    canvas.drawPath(path, paint);
  }

  void _drawEdges(Canvas canvas, List<Offset> projected, double progress) {
    final edgePaint = Paint()
      ..color = Color(0xFF9C27B0).withOpacity(progress * 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Front face edges
    canvas.drawLine(projected[0], projected[1], edgePaint);
    canvas.drawLine(projected[1], projected[2], edgePaint);
    canvas.drawLine(projected[2], projected[3], edgePaint);
    canvas.drawLine(projected[3], projected[0], edgePaint);

    // Connecting edges
    canvas.drawLine(projected[0], projected[4], edgePaint);
    canvas.drawLine(projected[1], projected[5], edgePaint);
    canvas.drawLine(projected[2], projected[6], edgePaint);
    canvas.drawLine(projected[3], projected[7], edgePaint);
  }

  void _drawTextOnFace(Canvas canvas, List<Offset> projected, StepData step, double progress) {
    final center = Offset(
      (projected[0].dx + projected[2].dx) / 2,
      (projected[0].dy + projected[2].dy) / 2,
    );

    // Draw number
    final numberPainter = TextPainter(
      text: TextSpan(
        text: step.number,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A148C).withOpacity(progress),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    numberPainter.paint(
      canvas,
      Offset(center.dx - 70, center.dy - 25),
    );

    // Draw title
    final titlePainter = TextPainter(
      text: TextSpan(
        text: step.title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF7B1FA2).withOpacity(progress),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    titlePainter.paint(
      canvas,
      Offset(center.dx - 10, center.dy - 25),
    );

    // Draw description
    final descPainter = TextPainter(
      text: TextSpan(
        text: step.description,
        style: TextStyle(
          fontSize: 8,
          color: Colors.grey.shade700.withOpacity(progress),
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: 160);

    descPainter.paint(
      canvas,
      Offset(center.dx - 70, center.dy + 5),
    );
  }

  void _drawIconConnector(Canvas canvas, int index, List<Offset> projected, StepData step, double progress) {
    final leftCenter = Offset(
      projected[0].dx,
      (projected[0].dy + projected[3].dy) / 2,
    );

    // Draw line
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(progress * 0.3)
      ..strokeWidth = 2;

    canvas.drawLine(
      leftCenter,
      Offset(leftCenter.dx - 60, leftCenter.dy),
      linePaint,
    );

    // Draw icon circle
    final iconCenter = Offset(leftCenter.dx - 90, leftCenter.dy);
    
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(progress)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(iconCenter, 25 * progress, circlePaint);

    final borderPaint = Paint()
      ..color = Color(0xFF9C27B0).withOpacity(progress)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(iconCenter, 25 * progress, borderPaint);

    // Draw icon (simplified)
    final iconPaint = Paint()
      ..color = Color(0xFF7B1FA2).withOpacity(progress)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(iconCenter, 12 * progress, iconPaint);
  }

  @override
  bool shouldRepaint(IsometricStairsPainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.progress != progress;
  }
}

class Vector3 {
  final double x;
  final double y;
  final double z;

  Vector3(this.x, this.y, this.z);
}

class StepData {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  StepData({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });
}