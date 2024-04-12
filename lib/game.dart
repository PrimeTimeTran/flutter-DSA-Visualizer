import 'package:flutter/material.dart';

import 'constants.dart';

Map<String, dynamic> createNode(rc, i, j) {
  return {
    'row': i,
    'col': i,
    'id': rc,
    'inRoute': false,
    'checked': false,
    'distance': false,
    'end': rc == END_NODE,
    'start': rc == START_NODE,
  };
}

List<List> getBoard() {
  List<List> board = [];
  for (int r = 0; r < ROWS; r++) {
    board.add([]);
    for (int c = 0; c < COLS; c++) {
      board[r].add([]);
      String rc = '$r,$c';
      Map<String, dynamic> cur = createNode(rc, r, c);
      board[r][c] = cur;
    }
  }
  return board;
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildRows(),
    );
  }

  _buildRows() {
    var board = getBoard();
    return List.generate(
      board.length,
      (rowIndex) => Row(
        children: List.generate(
          board[rowIndex].length,
          (colIndex) => Container(
            width: 20,
            height: 20,
            color: Colors.blue,
            child: Text(board[rowIndex][colIndex]['id']),
          ),
        ),
      ),
    );
  }
}
