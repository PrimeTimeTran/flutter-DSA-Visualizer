import 'dart:math';

List<int> sample(int limit, int sampleSize) {
  // Create an instance of the Random class
  var random = Random();

  // Create a set to store unique random numbers
  var sampledNumbers = <int>{};

  // Generate random numbers up to the limit until the sampledNumbers set reaches the desired size
  while (sampledNumbers.length < sampleSize) {
    // Generate a random number between 0 and the limit
    var randomNumber = random.nextInt(limit + 1);

    // Add the random number to the set (sets only store unique values)
    sampledNumbers.add(randomNumber);
  }

  // Convert the set to a list and return it
  return sampledNumbers.toList();
}
