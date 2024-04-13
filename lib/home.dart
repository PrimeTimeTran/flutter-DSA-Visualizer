import 'dart:math';

import 'package:flutter/material.dart';

import './models/graph.dart';

enum ArrowDirection {
  left,
  right,
  both,
  none,
}

class Home extends StatefulWidget {
  final Graph graph;
  const Home({super.key, required this.graph});

  @override
  State<Home> createState() => _HomeState();
}

class _GraphPainter extends CustomPainter {
  final Graph graph;
  _GraphPainter(this.graph);

  Offset calculateVertexPosition(int index) {
    const double centerY = 150.0;
    const double startingX = 100.0;
    const double circleRadius = 50.0;
    const double distanceBetweenVertices = 200.0;

    double x = startingX + index * distanceBetweenVertices;

    for (var i = 0; i < index; i++) {
      double previousX = startingX + i * distanceBetweenVertices;
      if ((x - previousX).abs() < 2 * circleRadius) {
        x = previousX + 2 * circleRadius;
      }
    }

    return Offset(x, centerY);
  }

  void drawEdge(Canvas canvas, Vertex vertex, Vertex neighbor, Paint paint,
      ArrowDirection arrowDirection) {
    paint.strokeWidth = 5;
    paint.color = Colors.red;
    const double arrowSize = 20;

    canvas.drawLine(
      Offset(vertex.x!, vertex.y!),
      Offset(neighbor.x!, neighbor.y!),
      paint,
    );

    // Draw arrow(s) if needed
    switch (arrowDirection) {
      case ArrowDirection.left:
        _drawArrow(canvas, Offset(vertex.x!, vertex.y!),
            Offset(neighbor.x!, neighbor.y!), arrowSize, 50, paint);
        break;
      case ArrowDirection.right:
        _drawArrow(canvas, Offset(neighbor.x!, neighbor.y!),
            Offset(vertex.x!, vertex.y!), arrowSize, 50, paint);
        break;
      case ArrowDirection.both:
        _drawArrow(canvas, Offset(vertex.x!, vertex.y!),
            Offset(neighbor.x!, neighbor.y!), arrowSize, 50, paint);
        _drawArrow(canvas, Offset(neighbor.x!, neighbor.y!),
            Offset(vertex.x!, vertex.y!), arrowSize, 50, paint);
        break;
      case ArrowDirection.none:
        break;
    }
  }

  void drawGrid(Size size, Canvas canvas, Paint paint) {
    const double cellSize = 20.0;
    for (double y = 0; y < size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  void drawVertexes(Canvas canvas, Paint paint) {
    const circleRadius = 25.0;
    for (var i = 0; i < graph.vertices.length; i++) {
      var vertex = graph.vertices[i];
      Offset circleCenter = calculateVertexPosition(i);
      vertex.x = circleCenter.dx;
      vertex.y = circleCenter.dy;

      canvas.drawCircle(circleCenter, circleRadius, paint);
      TextSpan span = TextSpan(
          text: vertex.id.toString(),
          style: const TextStyle(color: Colors.black));
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      for (var neighbor in vertex.neighbors) {
        drawEdge(canvas, vertex, neighbor, paint, ArrowDirection.left);
      }
      paint.color = Colors.grey;
      tp.layout();
      tp.paint(canvas, circleCenter - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.grey[300]!;

    drawGrid(size, canvas, paint);

    drawVertexes(canvas, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _drawArrow(Canvas canvas, Offset start, Offset end, double arrowSize,
      double nodeRadius, Paint paint) {
    final double angle = atan2(end.dy - start.dy, end.dx - start.dx);

    final double startAdjustX = cos(angle) * nodeRadius;
    final double startAdjustY = sin(angle) * nodeRadius;
    final double endAdjustX = cos(angle) * nodeRadius;
    final double endAdjustY = sin(angle) * nodeRadius;

    final Offset startAdjusted =
        Offset(start.dx + startAdjustX, start.dy + startAdjustY);
    final Offset endAdjusted = Offset(end.dx - endAdjustX, end.dy - endAdjustY);

    const double arrowAngle = pi / 6;
    final double arrowPoint1Angle = angle + pi - arrowAngle;
    final double arrowPoint2Angle = angle + pi + arrowAngle;

    final Offset arrowPoint1 = Offset(
        end.dx - arrowSize * cos(arrowPoint1Angle),
        end.dy - arrowSize * sin(arrowPoint1Angle));
    final Offset arrowPoint2 = Offset(
        end.dx - arrowSize * cos(arrowPoint2Angle),
        end.dy - arrowSize * sin(arrowPoint2Angle));
    canvas.drawLine(startAdjusted, endAdjusted, paint);
    canvas.drawLine(end, arrowPoint1, paint);
    canvas.drawLine(end, arrowPoint2, paint);
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _GraphPainter(widget.graph),
      ),
    );
  }

  Offset calculateVertexPosition(int index) {
    const double distanceBetweenVertices = 200.0;
    const double startingX = 100.0;
    const double centerY = 150.0;
    const double circleRadius = 50.0;

    double x = startingX + index * distanceBetweenVertices;

    for (var i = 0; i < index; i++) {
      double previousX = startingX + i * distanceBetweenVertices;
      if ((x - previousX).abs() < 2 * circleRadius) {
        x = previousX + 2 * circleRadius;
      }
    }

    return Offset(x, centerY);
  }

  calculateVertexPositions() {
    for (var i = 0; i < widget.graph.vertices.length; i++) {
      var vertex = widget.graph.vertices[i];
      Offset circleCenter = calculateVertexPosition(i);
      vertex.x = circleCenter.dx;
      vertex.y = circleCenter.dy;
    }
  }

  @override
  void initState() {
    super.initState();
    calculateVertexPositions();
  }
}
