import 'dart:async';
import 'dart:collection';

import '../constants.dart';
import '../utils.dart';
import 'node.dart';

typedef UpdateCallback = void Function();

class Board {
  int V = ROWS * COLS;
  List<Node> nodes = [];
  late String endId = END_NODE;
  late String startId = START_NODE;
  late UpdateCallback updateCallback;
  bool pathFound = false;

  late List<List> board;
  Board() {
    board = generateBoard();
  }

  get endNode {
    var keys = endId.split(',');
    return board[int.parse(keys[0])][int.parse(keys[1])];
  }

  get startNode {
    var keys = startId.split(',');
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
    List rows = sample(ROWS, 5);
    List cols = sample(COLS, 5);
    var lists = zipLists(rows, cols);
    for (var [r, c] in lists) {
      board[r][c].wall = true;
      if (inBounds(r + 2, c)) {
        board[r + 2][c].wall = true;
      }
      if (inBounds(r + 1, c)) {
        board[r + 1][c].wall = true;
      }
      if (inBounds(r - 1, c)) {
        board[r - 1][c].wall = true;
      }
      if (inBounds(r - 2, c)) {
        board[r - 2][c].wall = true;
      }
    }
    updateCallback();
  }

  handleFound(cur, parentMap, delay) async {
    pathFound = true;
    List<Node> path = [cur];
    while (cur != startNode) {
      cur = parentMap[cur]!;
      path.add(cur);
      await Future.delayed(delay);
      updateCallback();
    }
    Iterable list = path.reversed;
    var idx = 1;
    for (var cur in list) {
      cur.path = true;
      cur.step = idx;
      await Future.delayed(delay);
      updateCallback();
      idx += 1;
    }
  }

  bool inBounds(int r, int c) {
    return r >= 0 && r < ROWS && c >= 0 && c < COLS;
  }

  node(r, c) {
    return board[r][c];
  }

  randomize() {
    board[endNode.row][endNode.col].isEnd = false;
    int r = sample(ROWS, 1)[0];
    int c = sample(COLS, 1)[0];
    endId = '$r,$c';
    board[r][c].isEnd = true;
    board[r][c].wall = false;
  }

  reset() {
    for (int r = 0; r < ROWS; r++) {
      for (int c = 0; c < COLS; c++) {
        var node = board[r][c];
        if (!node.isEnd && !node.start) {
          node.visited = false;
          node.path = false;
          node.step = 1;
        }
        if (node.isEnd) {
          node.visited = false;
          node.path = false;
          node.step = 1;
        }
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
    var seen = <dynamic>{};
    Map<Node, Node> parentMap = {};
    var delay = const Duration(milliseconds: 5);

    queue.add(startNode);
    while (queue.isNotEmpty) {
      var nextLevel = Queue<Node>();
      while (queue.isNotEmpty) {
        Node cur = queue.removeFirst();
        if (cur.isEnd) {
          handleFound(cur, parentMap, delay);
          return;
        }
        updateCallback();
        if (!cur.start && !cur.isEnd) {
          // cur.visited = true;
          cur.setVisited(true);
        }
        await Future.delayed(delay);

        int r = cur.row!;
        int c = cur.col!;
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

            if (!neighbor.visited && !neighbor.wall) {
              nextLevel.add(neighbor);
              parentMap[neighbor] = cur;
            }
          }
        }
      }
      queue.addAll(nextLevel);
    }
  }
}
