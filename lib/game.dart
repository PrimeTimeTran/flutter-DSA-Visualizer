import 'package:f_dsa/widgets/cell.dart';
import 'package:flutter/material.dart';

import 'models/board.dart';
import 'models/node.dart';
import 'toasts.dart';

var greenButton = const ButtonStyle(
    foregroundColor: MaterialStatePropertyAll(Colors.white),
    backgroundColor: MaterialStatePropertyAll(Colors.green));

class MatrixPage extends StatefulWidget {
  const MatrixPage({super.key});

  @override
  State<MatrixPage> createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  late Board board;
  bool play = false;
  late Toaster toaster;
  @override
  Widget build(BuildContext context) {
    toaster = Toaster(context);
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
                    Container(height: 30, width: 30, color: Colors.blue[500]),
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
                board.makeMaze();
                toaster.displayInfoMotionToast('New maze created.');
              },
              child: const Text('New Maze'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                board.randomize();
                toaster.displayInfoMotionToast('New goal success.');
                board.updateCallback();
              },
              child: const Text('Move Goal Cell'),
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
                board.speed = 300;
                toaster.displayInfoMotionToast('Speed now 300 microseconds.');
                setState(() {});
              },
              style: greenButton,
              child: const Text('Fast'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                board.speed = 150;
                toaster.displayInfoMotionToast('Speed now 150 microseconds.');
                setState(() {});
              },
              style: greenButton,
              child: const Text('Faster'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                board.speed = 50;
                toaster.displayInfoMotionToast('Speed now 50 microseconds.');
                setState(() {});
              },
              style: greenButton,
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
            style: greenButton,
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
              toaster.displayInfoMotionToast('New Maze');
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
    board.makeMaze();
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
