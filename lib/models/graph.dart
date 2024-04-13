class Edge {
  final Vertex source;
  final Vertex destination;
  final double weight;
  final bool isDirected;

  Edge(this.source, this.destination,
      {this.weight = 1.0, this.isDirected = false});
}

class Graph {
  List<Vertex> vertices;
  List<Edge> edges;

  Graph({this.vertices = const [], this.edges = const []}) {
    for (Vertex vertex in vertices) {
      vertex.neighbors = [];
    }
    for (Edge edge in edges) {
      edge.source.neighbors.add(edge.destination);
      if (!edge.isDirected) {
        edge.destination.neighbors.add(edge.source);
      }
    }
  }
}

class Vertex {
  final String id;
  late List<Vertex> neighbors;
  late double? x;
  late double? y;

  Vertex(this.id);
}
