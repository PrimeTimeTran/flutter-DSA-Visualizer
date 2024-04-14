import 'package:flutter/material.dart';

import '../constants.dart';

class Node extends ChangeNotifier {
  int? row;
  int? col;
  late int layer = 0;
  final String id;
  bool inRoute = false;
  bool checked = false;
  bool visited = false;
  bool path = false;
  bool wall = false;
  late bool isEnd;
  late bool start;

  Node({
    required this.id,
    required this.row,
    required this.col,
    bool? isStart,
    bool? isEndNode,
    bool? isWall,
    bool? isVisited,
    bool? isPath,
  }) {
    isEnd = id == END_NODE;
    start = id == START_NODE;
    start = isStart ?? (id == START_NODE);
    isEnd = isEndNode ?? (id == END_NODE);
    wall = isWall ?? false;
    visited = isVisited ?? false;
    path = isPath ?? false;
  }
  get color {
    if (start) {
      return Colors.green;
    }
    if (isEnd) {
      return Colors.red;
    }
    if (wall) {
      return Colors.brown[800];
    }
    if (path) {
      return Colors.yellow;
    }
    if (visited) {
      return Colors.grey;
    }

    return Colors.lightBlue[50];
  }

  get radius {
    if (visited && !path) {
      return BorderRadius.circular(50);
    }
    return BorderRadius.circular(10);
  }

  void setVisited(bool value) {
    if (visited != value) {
      visited = value;
      notifyListeners();
    }
  }

  toggle() {
    wall = !wall;
  }
}
