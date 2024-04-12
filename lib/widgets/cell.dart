import 'package:flutter/material.dart';

import '../models/node.dart';

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
    return AnimatedContainer(
      width: 30,
      height: 30,
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.blue, width: 1),
      ),
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Text(
          widget.node.path
              ? '${widget.node.step == 1 ? '' : widget.node.step - 1}'
              : '',
          style: TextStyle(color: widget.node.path ? Colors.white : null),
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
      begin: Colors.grey,
      end: widget.node.path ? widget.node.color : Colors.blue[900],
    ).animate(_controller);
    widget.node.addListener(_onNodeColorChange);
  }

  void _onNodeColorChange() {
    if (widget.node.visited) {
      _controller.reset();
      _controller.forward();
      setState(() {}); // Trigger widget rebuild
    }
  }
}
