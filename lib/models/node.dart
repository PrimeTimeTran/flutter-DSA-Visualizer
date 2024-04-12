import 'package:flutter/material.dart';

import '../constants.dart';

class Node {
  final int row;
  final int col;
  final String id;
  bool inRoute = false;
  bool checked = false;
  bool visited = false;
  late bool end;
  late bool start;

  Node({
    required this.id,
    required this.row,
    required this.col,
  }) {
    end = id == END_NODE;
    start = id == START_NODE;
  }

  get color {
    if (visited) {
      return Colors.grey;
    }
    if (start) {
      return Colors.green;
    }
    if (end) {
      return Colors.red;
    }

    return Colors.blue;
  }

  toggle() {
    visited = !visited;
  }
}
