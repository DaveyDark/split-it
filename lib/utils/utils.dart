import 'dart:math';

import 'package:collection/collection.dart';

class Settlement {
  final String from;
  final String to;
  final double amount;

  Settlement(this.from, this.to, this.amount);
}

List<Settlement> settleSplit(Map<String, double> balance) {
  List<Settlement> settlements = [];
  PriorityQueue<String> positive =
      PriorityQueue((a, b) => balance[b]!.compareTo(balance[a]!));
  PriorityQueue<String> negative =
      PriorityQueue((a, b) => balance[a]!.compareTo(balance[b]!));
  positive.addAll(balance.keys.where((k) => balance[k]! > 0));
  negative.addAll(balance.keys.where((k) => balance[k]! < 0));

  while (positive.isNotEmpty && negative.isNotEmpty) {
    final String from = positive.removeFirst();
    final String to = negative.removeFirst();
    final double amount = min(balance[from]!, -balance[to]!);

    settlements.add(Settlement(from, to, amount));

    balance[from] = balance[from]! - amount;
    balance[to] = balance[to]! + amount;

    if (balance[from]! > 0) {
      positive.add(from);
    }

    if (balance[to]! < 0) {
      negative.add(to);
    }
  }

  return settlements;
}
