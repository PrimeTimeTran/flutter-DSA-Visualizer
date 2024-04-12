import 'dart:async';
import 'dart:collection';

import '../constants.dart';
import 'node.dart';

typedef UpdateCallback = void Function();

class Board {
  int V = ROWS * COLS;
  late UpdateCallback updateCallback;

  late List<List> board;
  Board() {
    board = generateBoard();
  }

  get endNode {
    var keys = END_NODE.split(',');
    return board[int.parse(keys[0])][int.parse(keys[1])];
  }

  get startNode {
    var keys = START_NODE.split(',');
    return board[int.parse(keys[0])][int.parse(keys[1])];
  }

  void applyOffsetsAndVisualize(List<Node> nodes) {
    const delay = Duration(milliseconds: 500);
    for (int i = 0; i < nodes.length; i++) {
      print(i);
      Node node = nodes[i];
      int offset = i * delay.inMilliseconds;
      Timer(Duration(milliseconds: offset), () {
        node.visited = true;
        updateCallback();
      });
    }
  }

  BFS() async {
    Queue<Node> queue = Queue();
    queue.add(board[startNode.row][startNode.col]);
    var delay = const Duration(milliseconds: 1);
    var seen = <dynamic>{};

    while (queue.isNotEmpty) {
      var nextLevel = Queue<Node>();

      while (queue.isNotEmpty) {
        Node cur = queue.removeFirst();
        updateCallback();
        if (!cur.start && !cur.end) {
          cur.visited = true;
        }
        await Future.delayed(delay);

        int r = cur.row;
        int c = cur.col;
        List<List> neighbors = [
          [r - 1, c],
          [r + 1, c],
          [r, c + 1],
          [r, c - 1]
        ];
        for (var element in neighbors) {
          var nr = element[0];
          var nc = element[1];
          if (inBounds(nr, nc) && !seen.contains('$nr,$nc')) {
            seen.add('$nr,$nc');

            Node neighbor = board[nr][nc];
            if (!neighbor.visited) {
              nextLevel.add(neighbor);
            }
          }
        }
      }
      queue.addAll(nextLevel);
    }
  }

  List<List> generateBoard() {
    List<List> board = [];
    for (int r = 0; r < ROWS; r++) {
      board.add([]);
      for (int c = 0; c < COLS; c++) {
        board[r].add([]);
        String rc = '$r,$c';
        Node cur = Node(id: rc, row: r, col: c);
        board[r][c] = cur;
      }
    }
    return board;
  }

  bool inBounds(int r, int c) {
    return r >= 0 && r < ROWS && c >= 0 && c < COLS;
  }

  node(r, c) {
    return board[r][c];
  }

  search() async {
    BFS();
    // for (int r = 0; r < ROWS; r++) {
    //   for (int c = 0; c < COLS; c++) {
    //     Node cur = board[r][c];
    //     int delay = r * COLS + c;
    //     Future.delayed(Duration(milliseconds: delay * 100), () {
    //       cur.visited = true;
    //       updateCallback();
    //     });
    //   }
    // }
  }
}
