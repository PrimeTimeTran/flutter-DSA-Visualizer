import 'package:f_dsa/widgets/cell.dart';
import 'package:flutter/material.dart';

import 'models/board.dart';
import 'models/node.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Board board;
  bool play = false;
  int speed = 500;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildPanel(),
          ..._buildMatrix(),
        ],
      ),
    );
  }

  Expanded buildCol1() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Legend'),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Cell(
                        node: Node(row: 0, col: 0, id: '10,20', isStart: true),
                      ),
                      const SizedBox(width: 10),
                      const Text('Start'),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Cell(
                        node: Node(row: 0, col: 0, id: '10,20', isPath: true),
                      ),
                      const SizedBox(width: 10),
                      const Text('Path'),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Cell(
                        node:
                            Node(row: 0, col: 0, id: '10,20', isEndNode: true),
                      ),
                      const SizedBox(width: 10),
                      const Text('End'),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Cell(
                        node:
                            Node(row: 0, col: 0, id: '10,20', isVisited: false),
                      ),
                      const SizedBox(width: 10),
                      const Text('Unvisited'),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Cell(
                        node: Node(row: 0, col: 0, id: '10,20', isWall: true),
                      ),
                      const SizedBox(width: 10),
                      const Text('Wall'),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(height: 30, width: 30, color: Colors.blue[900]),
                    const SizedBox(width: 5),
                    Cell(
                      node: Node(row: 0, col: 0, id: '10,20', isVisited: true),
                    ),
                    const SizedBox(width: 10),
                    const Text('Visited'),
                  ],
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildCol2() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                board.generateWalls();
              },
              child: const Text('Generate Walls'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                board.reset();
                board.updateCallback();
              },
              child: const Text('Reset'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                board.randomize();
                board.updateCallback();
              },
              child: const Text('Randomize'),
            )
          ],
        ),
      ),
    );
  }

  Expanded buildCol3() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                board.speed = 500;
                setState(() {
                  speed = 500;
                });
              },
              style: ButtonStyle(
                  backgroundColor: speed == 500
                      ? const MaterialStatePropertyAll(Colors.green)
                      : null),
              child: const Text('Fast'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                board.speed = 250;
                setState(() {
                  speed = 250;
                });
              },
              style: ButtonStyle(
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  backgroundColor: speed == 250
                      ? const MaterialStatePropertyAll(Colors.green)
                      : null),
              child: const Text('Faster'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                board.speed = 5;
                setState(() {
                  speed = 5;
                });
              },
              style: ButtonStyle(
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  backgroundColor: speed == 5
                      ? const MaterialStatePropertyAll(Colors.green)
                      : null),
              child: const Text('Fastest'),
            )
          ],
        ),
      ),
    );
  }

  Expanded buildCol4() {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton(
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.white),
              backgroundColor: MaterialStatePropertyAll(Colors.green),
            ),
            onPressed: () {
              board.searchBFS();
            },
            child: const Text('Search'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.white),
              backgroundColor: MaterialStatePropertyAll(Colors.red),
            ),
            onPressed: () {
              board.reset();
              board.updateCallback();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Row buildPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCol1(),
        buildCol2(),
        buildCol3(),
        buildCol4(),
      ],
    );
  }

  @override
  void initState() {
    board = Board();
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

    return Cell(node: node);
  }

  _buildMatrix() {
    return List.generate(
      board.board.length,
      (row) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          board.board[row].length,
          (col) => _buildCell(row, col),
        ),
      ),
    );
  }
}
