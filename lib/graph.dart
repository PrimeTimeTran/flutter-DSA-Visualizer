import 'package:flutter/material.dart';

import './models/graph.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

Graph simpleGraph = Graph(vertices: vertices, edges: [
  Edge(vertices[0], vertices[1]),
  Edge(vertices[2], vertices[3]),
]);

var vertices = [
  Vertex('A'),
  Vertex('B'),
  Vertex('C'),
  Vertex('D'),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Data Structures & Algorithms'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Home(),
    );
  }
}
