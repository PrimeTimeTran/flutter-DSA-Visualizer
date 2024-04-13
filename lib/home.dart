import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Random r = Random();
  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  add() {
    final node3 = Node.Id(r.nextInt(100));
    var edge = graph.getNodeAtPosition(r.nextInt(graph.nodeCount()));
    print(edge);
    graph.addEdge(edge, node3);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.01,
          maxScale: 5.6,
          child: GraphView(
            graph: graph,
            algorithm:
                BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
            paint: Paint()
              ..color = Colors.green
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              var a = node.key?.value as int;
              return rectangleWidget(a);
            },
          )),
    );
  }

  @override
  void initState() {
    final node1 = Node.Id(1);
    final node2 = Node.Id(2);
    final node3 = Node.Id(3);
    final node4 = Node.Id(4);
    final node5 = Node.Id(5);
    final node6 = Node.Id(6);

    graph.addEdge(node1, node2);
    graph.addEdge(node1, node3);
    graph.addEdge(node4, node5);
    graph.addEdge(node5, node6, paint: Paint());
    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (50)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  Widget rectangleWidget(int a) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Colors.red,
      ),
    );
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Node $a Clicked"),
          duration: const Duration(seconds: 2, milliseconds: 500),
        ));
        // print('clicked');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 1),
          ],
        ),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: const [
                    BoxShadow(color: Colors.green, spreadRadius: 1),
                  ],
                ),
                child: Text('Node $a')),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                add();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, spreadRadius: 1),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
