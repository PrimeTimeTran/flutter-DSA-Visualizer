import 'package:flutter/material.dart';

import 'sort.dart';

void main() {
  runApp(const MyApp());
}

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Messages',
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('DSA Visualizer'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_filled),
                label: Text('Sorting'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.home_filled),
                label: Text('Matrix'),
              )
            ],
            selectedIndex: currentPageIndex,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          const Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [SortPage()],
            ),
          ))
        ],
      ),
    );
  }
}
