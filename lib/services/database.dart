import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:split_it/models/split.dart';
import 'package:split_it/models/transaction.dart';
import 'package:split_it/utils/utils.dart';

class DB {
  late Isar isar;
  static final DB _instance = DB._internal();

  factory DB() => _instance;

  DB._internal();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        SplitSchema,
        TransactionSchema,
      ],
      directory: dir.path,
    );
  }

  Future<void> createSplit(String title, List<String> contributors) async {
    final split = Split()
      ..title = title
      ..settled = false
      ..created = DateTime.now()
      ..contributors = contributors;
    isar.writeTxn(() async {
      await isar.splits.put(split);
    });
  }

  Future<void> addContributor(int splitId, String contributor) async {
    final split = await isar.splits.get(splitId);
    split!.contributors = [...split.contributors, contributor];
    isar.writeTxn(() async {
      await isar.splits.put(split);
    });
  }

  Future<List<Split>> getActiveSplits() async {
    return await isar.splits
        .filter()
        .settledEqualTo(false)
        .sortByCreatedDesc()
        .findAll();
  }

  Future<List<Split>> getSettledSplits() async {
    return await isar.splits
        .filter()
        .settledEqualTo(true)
        .sortByCreatedDesc()
        .findAll();
  }

  Future<Split?> getSplit(int id) async {
    return await isar.splits.get(id);
  }

  Stream<void> watchSplits() {
    return DB().isar.splits.watchLazy();
  }

  Stream<void> watchSplit(int id) {
    return DB().isar.splits.watchObjectLazy(id);
  }

  Stream<void> watchTransactions() {
    return DB().isar.transactions.watchLazy();
  }

  Future<void> createTransaction(
    int splitId,
    String title,
    double amount,
    String contributor,
  ) async {
    final split = await isar.splits.get(splitId);
    final contributorIndex = split!.contributors.indexOf(contributor);
    final transaction = Transaction()
      ..description = title
      ..amount = amount
      ..contributor = contributorIndex;
    isar.writeTxn(() async {
      await isar.transactions.put(transaction);
      split.transactions.add(transaction);
      await split.transactions.save();
      await isar.splits.put(split);
    });
  }

  Future<Map<String, double>> getContributions(int splitId) async {
    final split = await isar.splits.get(splitId);
    final transactions = split!.transactions.toList();
    final contributions = <String, double>{};
    for (final transaction in transactions) {
      final contributor = split.contributors[transaction.contributor];
      contributions[contributor] =
          (contributions[contributor] ?? 0) + transaction.amount;
    }
    return contributions;
  }

  Future<Map<String, double>> getBalance(int splitId) async {
    final split = await isar.splits.get(splitId);
    final contributions = await getContributions(splitId);
    final total = contributions.values.fold(0.0, (a, b) => a + b);
    final avg = total / split!.contributors.length;
    final settlement = <String, double>{};
    for (final contributor in split.contributors) {
      final contribution = contributions[contributor] ?? 0;
      settlement[contributor] = avg - contribution;
    }
    return settlement;
  }

  Future<double> getTotal(int splitId) async {
    final split = await isar.splits.get(splitId);
    final transactions = split!.transactions.toList();
    double total = 0;
    for (final transaction in transactions) {
      total += transaction.amount;
    }
    return total;
  }

  Future<List<Settlement>> getSettlement(int splitId) async {
    final bal = await getBalance(splitId);
    final settlements = settleSplit(bal);
    return settlements;
  }

  Future<void> markSplit(int splitId) async {
    final split = await isar.splits.get(splitId);
    final bal = await getBalance(splitId);
    final settlements = settleSplit(bal);
    isar.writeTxn(() async {
      for (final settlement in settlements) {
        final transaction = Transaction()
          ..description = "Settlement"
          ..amount = settlement.amount
          ..contributor = split!.contributors.indexOf(settlement.from);
        await isar.transactions.put(transaction);
        split.transactions.add(transaction);
      }
      await split!.transactions.save();
      split.settled = true;
      await isar.splits.put(split);
    });
  }
}
