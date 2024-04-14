import 'package:flutter/material.dart';

import '../models/node.dart';

Color makeColor(int delta) {
  Color baseColor = Colors.blue[500]!;

  int red = baseColor.red - delta * 2;
  int blue = baseColor.blue - delta * 2;
  int green = baseColor.green - delta * 2;

  red = red.clamp(0, 255);
  blue = blue.clamp(0, 255);
  green = green.clamp(0, 255);

  return Color.fromARGB(baseColor.alpha, red, green, blue);
}

class Cell extends StatefulWidget {
  final Node node;
  const Cell({super.key, required this.node});

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> animation;

  @override
  Widget build(BuildContext context) {
    Color color = widget.node.visited ? animation.value : widget.node.color;
    color = widget.node.path ? widget.node.color : color;
    return GestureDetector(
      onTap: () {
        widget.node.toggle();
        setState(() {});
      },
      onDoubleTap: () {
        widget.node.visited = !widget.node.visited;
        setState(() {});
      },
      child: AnimatedContainer(
        width: 30,
        height: 30,
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black87, width: 1),
        ),
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Text(
            widget.node.path
                ? '${widget.node.layer == 0 ? '' : widget.node.layer}'
                : '',
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.orange,
      end: widget.node.path ? widget.node.color : makeColor(widget.node.layer),
    ).animate(_controller);
    widget.node.addListener(_onNodeColorChange);
  }

  void _onNodeColorChange() {
    if (widget.node.visited) {
      _controller.reset();
      _controller.forward();
      setState(() {});
    }
  }
}
