import 'dart:async';
import 'dart:collection';
import 'dart:math';

import '../constants.dart';
import '../utils.dart';
import 'node.dart';

typedef UpdateCallback = void Function();

class Board {
  int V = ROWS * COLS;
  int speed = 1;
  List<Node> nodes = [];
  late String endId = END_NODE;
  late String startId = START_NODE;
  late UpdateCallback updateCallback;
  bool pathFound = false;

  late List<List<Node>> board;
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

  List<List<Node>> generateBoard() {
    List<List<Node>> board = [];
    for (int r = 0; r < ROWS; r++) {
      List<Node> items = [];
      board.add(items);
      for (int c = 0; c < COLS; c++) {
        String rc = '$r,$c';
        Node cur = Node(id: rc, row: r, col: c);
        board[r].add(cur);
        nodes.add(cur);
        board[r][c] = cur;
      }
    }
    return board;
  }

  generateWalls() {
    for (int r = 0; r < ROWS; r++) {
      for (int c = 0; c < COLS; c++) {
        if (inBounds(r, c)) {
          Node node = board[r][c];
          node.wall = false;
        }
      }
    }
    updateCallback();
    makeMaze();
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

  makeMaze() {
    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        if (inBounds(row, col)) {
          board[row][col].wall = false;
        }
      }
    }
    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        if ((row % 2 != 0 && row != 0) && col % 2 != 0) {
          board[row][col].wall = false;
        } else {
          board[row][col].wall = true;
        }
      }
    }

    _generatePassages();
    updateCallback();
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

  searchBFS() async {
    Queue<Node> queue = Queue();
    var seen = <dynamic>{};
    Map<Node, Node> parentMap = {};

    queue.add(startNode);
    while (queue.isNotEmpty) {
      Node cur = queue.removeFirst();
      if (cur.isEnd) {
        handleFound(cur, parentMap, const Duration(microseconds: 1));
        return;
      }
      if (!cur.start && !cur.isEnd) {
        cur.setVisited(true);
        updateCallback();
        await Future.delayed(
          const Duration(microseconds: 1),
        );
      }

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
            queue.add(neighbor);
            parentMap[neighbor] = cur;
          }
        }
      }
    }
  }

  void _generatePassages() {
    Random random = Random();
    int startRow = random.nextInt(ROWS);
    board[startRow][0].wall = false;

    _visit(startRow, 0);
  }

  void _visit(int row, int col) {
    var directions = [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0]
    ]; // right, left, down, up

    directions.shuffle();
    for (var dir in directions) {
      int newRow = row + dir[0] * 2;
      int newCol = col + dir[1] * 2;

      if (newRow >= 0 && newRow < ROWS && newCol >= 0 && newCol < COLS) {
        if (board[newRow][newCol].wall) {
          // Knock down the wall
          board[newRow][newCol].wall = false;
          board[row + dir[0]][col + dir[1]].wall = false;

          _visit(newRow, newCol);
        }
      }
    }
  }
}
