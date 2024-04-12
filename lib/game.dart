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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildMatrix(),
    );
  }

  @override
  void initState() {
    super.initState();
    board.updateCallback = () => setState(() {});
    board.BFS();
  }

  _buildCell(r, c) {
    Node node = board.node(r, c);

    return GestureDetector(
      onTap: () {
        setState(() {
          node.toggle();
        });
      },
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
