import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'utils.dart';

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

enum SortOption { bubble, selection, insertion, merge }

class SortPage extends StatefulWidget {
  const SortPage({super.key});

  @override
  State<SortPage> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage>
    with SingleTickerProviderStateMixin {
  int numsLength = 20;
  late List<int> nums;
  bool finishedSort = false;
  late List<SortItem> sortItems = [];
  SortOption sortType = SortOption.bubble;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSortItemOptions(),
              buildSortPanel(),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _sort(sortType),
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green)),
                          child: const Text(
                            'Sort',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 900,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              sortItems.length,
              buildSortItem,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSortItem(index) {
    SortItem item = sortItems[index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedPositioned(
          bottom: 0,
          left: item.position * 50.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: 20,
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
        ),
        Text(item.value.toString()),
        Text(nums[index].toString()),
      ],
    );
  }

  Expanded buildSortItemOptions() {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (numsLength > 40) {
                  return;
                }
                setState(() {
                  numsLength += 5;
                });
                generateItems();
              },
              child: const Text('Add Sort Items'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (numsLength > 40) {
                  return;
                }
                setState(() {
                  numsLength -= 5;
                });
                generateItems();
              },
              child: const Text('Remove Sort Items'),
            ),
          ],
        ),
      ),
    );
  }

  String buildSortLabel(type) {
    return capitalize(type.toString().split('.')[1].split('Sort')[0]);
  }

  Expanded buildSortPanel() {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildSortButton(SortOption.bubble),
            const SizedBox(height: 10),
            _buildSortButton(SortOption.selection),
            const SizedBox(height: 10),
            _buildSortButton(SortOption.insertion),
            const SizedBox(height: 10),
            _buildSortButton(SortOption.merge),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  generateItems() {
    nums = generateRandomNumbers();
    nums.shuffle();
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
    setState(() {
      nums = nums;
      sortItems = sortItems;
    });
  }

  List<int> generateRandomNumbers() {
    Random random = Random();
    List<int> numbers = [];

    for (int i = 0; i < numsLength; i++) {
      numbers.add(random.nextInt(numsLength + 1));
    }
    numbers.shuffle();
    return numbers;
  }

  @override
  void initState() {
    super.initState();
    generateItems();
  }

  Future<void> _bubble(List<SortItem> items) async {
    int n = items.length;
    bool sorted = false;
    while (!sorted) {
      sorted = true;
      for (int i = 0; i < n - 1; i++) {
        for (var item in items) {
          item.sorting = false;
        }
        SortItem left = items[i];
        SortItem right = items[i + 1];
        left.sorting = true;
        right.sorting = true;
        setState(() {});
        bool shouldSwap = right.value < left.value;
        if (shouldSwap) {
          sorted = false;
          items[i] = right;
          items[i + 1] = left;
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 500));
        }
        left.sorting = false;
        right.sorting = false;
        setState(() {});
      }
    }
    setState(() {});
  }

  _buildSortButton(SortOption option) {
    ButtonStyle? style;
    TextStyle? textStyle;
    if (sortType == option) {
      textStyle = const TextStyle(color: Colors.white);
      style = const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          Colors.green,
        ),
      );
    }
    return ElevatedButton(
      style: style,
      onPressed: () {
        setState(() => sortType = option);
      },
      child: Text('${buildSortLabel(option)} Sort', style: textStyle),
    );
  }

  Future<void> _insertion(List<SortItem> items) async {
    int n = items.length;

    for (int i = 1; i < n; i++) {
      SortItem key = items[i];
      int j = i - 1;

      while (j >= 0 && items[j].value > key.value) {
        items[j + 1] = items[j];
        j = j - 1;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));
      }

      items[j + 1] = key;

      setState(() {});
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {});
  }

  Future<List<SortItem>> _merge(
      List<SortItem> left, List<SortItem> right) async {
    List<SortItem> res = [];
    int l = 0, r = 0;
    while (l < left.length && r < right.length) {
      if (left[l].value < right[r].value) {
        res.add(left[l]);
        left[l].sorting = true;
        l++;
      } else {
        res.add(right[r]);
        right[r].sorting = true;
        r++;
      }
    }

    res.addAll(left);
    res.addAll(right);
    await Future.delayed(const Duration(milliseconds: 500), () {
      left[l].sorting = true;
      right[r].sorting = true;
      setState(() => {});
    });
    return res;
  }

  Future<List<SortItem>> _mergeSort(List<SortItem> items) async {
    if (items.length < 2) {
      return items;
    }
    await Future.delayed(const Duration(milliseconds: 500));

    int midIdx = items.length ~/ 2;

    List<SortItem> left = items.sublist(0, midIdx);
    List<SortItem> right = items.sublist(midIdx);
    return _merge(await _mergeSort(left), await _mergeSort(right));
  }

  Future<void> _selection(List<SortItem> items) async {
    int n = items.length;

    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < n; j++) {
        items[j].sorting = true;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));

        if (items[j].value < items[minIndex].value) {
          minIndex = j;
        }

        items[j].sorting = false;
        setState(() {});
      }

      if (minIndex != i) {
        SortItem temp = items[minIndex];
        items[minIndex] = items[i];
        items[i] = temp;

        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    setState(() {});
  }

  _sort(SortOption option) async {
    switch (option) {
      case SortOption.bubble:
        await _bubble(sortItems);
        break;
      case SortOption.insertion:
        await _selection(sortItems);
        break;
      case SortOption.selection:
        await _insertion(sortItems);
        break;
      default:
    }
    setState(() {
      finishedSort = true;
    });
  }
}
