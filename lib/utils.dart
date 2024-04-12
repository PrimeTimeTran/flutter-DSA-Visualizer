import 'dart:math';

List<int> sample(int limit, int sampleSize) {
  var random = Random();
  var sampledNumbers = <int>{};
  while (sampledNumbers.length < sampleSize) {
    var randomNumber = random.nextInt(limit + 1);
    sampledNumbers.add(randomNumber);
  }

  return sampledNumbers.toList();
}

List<List<T>> zipLists<T>(List<T> list1, List<T> list2) {
  if (list1.length != list2.length) {
    throw ArgumentError('Lists must have the same length');
  }

  List<List<T>> zippedList = [];
  for (int i = 0; i < list1.length; i++) {
    zippedList.add([list1[i], list2[i]]);
  }
  return zippedList;
}
