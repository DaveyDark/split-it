import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;
  late int contributor;
  late String description;
  late double amount;
}
