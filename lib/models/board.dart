import 'dart:async';
import 'dart:collection';

import '../constants.dart';
import '../utils.dart';
import 'node.dart';

typedef UpdateCallback = void Function();

class Board {
  int V = ROWS * COLS;
  List<Node> nodes = [];
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

  List<List> generateBoard() {
    List<List> board = [];
    for (int r = 0; r < ROWS; r++) {
      board.add([]);
      for (int c = 0; c < COLS; c++) {
        board[r].add([]);
        String rc = '$r,$c';
        Node cur = Node(id: rc, row: r, col: c);
        nodes.add(cur);
        board[r][c] = cur;
      }
    }
    return board;
  }

  generateWalls() {
    List count = sample(ROWS, 5);
    for (var element in count) {
      board[element][0].wall = true;
    }
  }

  bool inBounds(int r, int c) {
    return r >= 0 && r < ROWS && c >= 0 && c < COLS;
  }

  node(r, c) {
    return board[r][c];
  }

  reset() {
    for (var node in nodes) {
      if (!node.end && !node.start) {
        node.visited = false;
        node.path = false;
      }
    }
  }

  search() async {
    // ignore: non_constant_identifier_names
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

  searchBFS() async {
    Queue<Node> queue = Queue();
    int distance = 0;
    var seen = <dynamic>{};
    Map<Node, Node> parentMap = {};
    var delay = const Duration(milliseconds: 10);

    queue.add(board[startNode.row][startNode.col]);
    while (queue.isNotEmpty) {
      var nextLevel = Queue<Node>();
      while (queue.isNotEmpty) {
        Node cur = queue.removeFirst();
        if (cur.end) {
          while (cur != startNode) {
            cur.path = true;
            cur = parentMap[cur]!;
            await Future.delayed(delay);
            updateCallback();
          }
          return;
        }
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
        for (var [nr, nc] in neighbors) {
          if (inBounds(nr, nc) && !seen.contains('$nr,$nc')) {
            seen.add('$nr,$nc');
            Node neighbor = board[nr][nc];
            if (!neighbor.visited) {
              nextLevel.add(neighbor);
              parentMap[neighbor] = cur;
            }
          }
        }
      }
      distance += 1;
      queue.addAll(nextLevel);
    }
  }
}
