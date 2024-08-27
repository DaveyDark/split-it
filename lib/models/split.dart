import 'package:isar/isar.dart';

import 'transaction.dart';

part 'split.g.dart';

@collection
class Split {
  Id id = Isar.autoIncrement;
  late String title;
  late List<String> contributors;
  final transactions = IsarLinks<Transaction>();
  late bool settled;
  late DateTime created;
}
