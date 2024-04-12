import 'package:flutter/material.dart';

import 'models/board.dart';
import 'models/node.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Board board = Board();
  bool play = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        ElevatedButton(
          onPressed: () {
            board.randomize();
            board.updateCallback();
          },
          child: const Text('Randomize'),
        ),
        ..._buildMatrix(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    board.updateCallback = () {
      if (!play) {
        setState(() {});
      }
    };
    board.generateWalls();
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
      child: AnimatedContainer(
        margin: const EdgeInsets.all(1),
        width: 40,
        height: 40,
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          borderRadius: node.radius,
          color: node.color,
        ),
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Text(
            node.path ? '${node.step == 1 ? '' : node.step - 1}' : '',
            style: TextStyle(color: node.path ? Colors.white : null),
          ),
        ),
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
