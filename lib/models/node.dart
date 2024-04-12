import 'package:flutter/material.dart';

import '../constants.dart';

class Node {
  int row;
  int col;
  int step = 0;
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
  }) {
    isEnd = id == END_NODE;
    start = id == START_NODE;
  }

  get color {
    if (start) {
      return Colors.green;
    }
    if (isEnd) {
      return Colors.red;
    }
    if (wall) {
      return Colors.brown[700];
    }
    if (path) {
      return Colors.purple;
    }
    if (visited) {
      return Colors.grey;
    }

    return Colors.blue;
  }

  get radius {
    if (visited && !path) {
      return BorderRadius.circular(50);
    }
    return BorderRadius.circular(10);
  }

  toggle() {
    visited = !visited;
  }
}
