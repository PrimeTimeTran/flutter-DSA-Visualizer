import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class BoxWidget extends StatelessWidget {
  final Animation<Offset> position;
  final Function callBack;
  final String text;
  final Color color;
  final double height;
  final SortItem item;

  const BoxWidget({
    super.key,
    required this.position,
    required this.callBack,
    required this.text,
    required this.color,
    required this.height,
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: position,
      child: GestureDetector(
        onTap: () => callBack(),
        child: Container(
          width: 50,
          color: item.color,
          height: item.height,
          margin: const EdgeInsets.all(10),
          child: Center(
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(child: Text(item.label)),
            ),
          ),
        ),
      ),
    );
  }
}

class SortItem {
  Color color;
  num value;
  late int position;
  String label;
  double height;
  late bool sorting = false;
  SortItem({
    required this.value,
    required this.height,
    required this.color,
    required this.position,
    required this.label,
  });
}

class SortPage extends StatefulWidget {
  const SortPage({super.key});

  @override
  State<SortPage> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage>
    with SingleTickerProviderStateMixin {
  late List<int> nums;
  late List<SortItem> sortItems = [];
  // late AnimationController _controller;
  late AnimationController _controller;
  late List<Animation<Offset>> _offsetAnimation;
  final bool _sortingInProgress = false;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 1000,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          sortItems.length,
          (index) {
            SortItem item = sortItems[index];
            // return BoxWidget(
            //   item: item,
            //   height: item.height,
            //   callBack: _animate,
            //   text: item.label,
            //   color: item.color,
            //   position: _offsetAnimation[item.position],
            // );
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              left: item.position * 50.0,
              bottom: 0,
              child: Container(
                width: 40,
                height: item.height,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: item.color,
                  border: item.sorting
                      ? Border.all(color: Colors.black, width: 5)
                      : null,
                ),
                child: Center(child: Text(item.label)),
              ),
            );
          },
        ),
      ),
    );
  }

  generateItems() {
    sortItems = List.generate(
      nums.length,
      (index) {
        num item = nums[index];
        Color color = Color.fromRGBO(
          Random().nextInt(256),
          Random().nextInt(256),
          Random().nextInt(256),
          1.0,
        );
        return SortItem(
            color: color,
            value: item,
            position: index,
            label: item.toString(),
            height: item.toDouble() * 20);
      },
    );
  }

  List<int> generateRandomNumbers(int length, int max) {
    Random random = Random();
    List<int> numbers = [];

    for (int i = 0; i < length; i++) {
      numbers.add(random.nextInt(max + 1));
    }
    numbers.shuffle();
    return numbers;
  }

  @override
  void initState() {
    super.initState();
    nums = generateRandomNumbers(15, 20);
    generateItems();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bubbleSort(sortItems);

    // _controller = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // );
    // _offsetAnimation = List.generate(
    //   sortItems.length,
    //   (index) => Tween<Offset>(
    //     begin: const Offset(0.0, 0.0),
    //     end: Offset(index == 0 ? 1 : -1, 0.0),
    //   ).animate(_controller),
    // );

    // Future.delayed(const Duration(seconds: 1), () {
    //   _bubbleSort(sortItems);
    // });
  }

  void _animate() {
    _controller.status == AnimationStatus.completed
        ? _controller.reverse()
        : _controller.forward();
  }

  Future<void> _bubbleSort(List<SortItem> items) async {
    int n = items.length;
    bool sorted = false;
    while (!sorted) {
      sorted = true;
      for (int i = 0; i < n - 1; i++) {
        if (items[i].value > items[i + 1].value) {
          await _swap(items, i, i + 1);
          sorted = false;
          setState(() {});
        }
      }
      n--;
    }
  }

  Future<void> _swap(List<SortItem> items, int index1, int index2) async {
    SortItem temp = items[index1];
    items[index1] = items[index2];
    items[index2] = temp;
    int tempPosition = items[index1].position;
    items[index1].position = items[index2].position;
    items[index2].position = tempPosition;
    items[index1].sorting = true;
    items[index2].sorting = true;
    await Future.delayed(const Duration(milliseconds: 500));
    items[index1].sorting = false;
    items[index2].sorting = false;
    setState(() {});
  }
}
