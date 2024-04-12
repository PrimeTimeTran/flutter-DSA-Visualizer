import 'package:flutter/material.dart';

import 'models/board.dart';
import 'models/node.dart';

class Game extends StatefulWidget {
  bool play;
  Game({super.key, required this.play});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Board board = Board();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._buildMatrix(),
        ElevatedButton(
          onPressed: () {
            board.searchBFS();
          },
          child: const Text('Search'),
        ),
        ElevatedButton(
          onPressed: () {
            board.generateWalls();
          },
          child: const Text('Generate Walls'),
        ),
        ElevatedButton(
          onPressed: () {
            board.reset();
            board.updateCallback();
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    board.updateCallback = () {
      if (!widget.play) {
        setState(() {});
      }
    };
    board.generateWalls();
    board.searchBFS();
  }

  setupCallback() {}

  _buildCell(r, c) {
    Node node = board.node(r, c);

    return GestureDetector(
      onTap: () {
        setState(() {
          node.toggle();
        });
      },
      // onVerticalDragStart: (DragStartDetails el) {
      //   print(el);
      // },
      child: Container(
        margin: const EdgeInsets.all(1),
        width: 40,
        height: 40,
        color: node.color,
        child: Center(child: Text(node.id)),
      ),
    );
  }

  _buildMatrix() {
    return List.generate(
      board.board.length,
      (row) => Row(
        children: List.generate(
          board.board[row].length,
          (col) => _buildCell(row, col),
        ),
      ),
    );
  }
}
