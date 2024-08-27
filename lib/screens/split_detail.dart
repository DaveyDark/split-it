import 'package:flutter/material.dart';
import 'package:split_it/services/database.dart';
import 'package:split_it/models/split.dart' as split_model;
import 'package:split_it/utils/theme.dart' as theme;
import 'package:split_it/utils/utils.dart';
import 'package:split_it/widgets/add_transaction.dart';
import 'package:split_it/widgets/modal_controls.dart';

class SplitDetail extends StatefulWidget {
  const SplitDetail({
    super.key,
    required this.id,
    required this.editable,
  });

  final String id;
  final bool editable;

  @override
  State<SplitDetail> createState() => _SplitDetailState();
}

class _SplitDetailState extends State<SplitDetail> {
  split_model.Split? split;
  double total = 0;
  Map<String, double> contributions = {};
  Map<String, double> balance = {};
  List<Settlement> settlements = [];

  Future<void> _getSplit() async {
    final id = int.parse(widget.id);
    final s = await DB().getSplit(id);
    final t = await DB().getTotal(id);
    final contris = await DB().getContributions(id);
    final bal = await DB().getBalance(id);
    final sett = await DB().getSettlement(id);
    setState(() {
      split = s;
      total = t;
      contributions = contris;
      balance = bal;
      settlements = sett;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSplit();
    DB().watchTransactions().listen((_) {
      _getSplit();
    });
    DB().watchSplit(int.parse(widget.id)).listen((_) {
      _getSplit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          split?.title ?? "Split Details",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _Details(
        split: split,
        total: total,
        contributions: contributions,
        balance: balance,
        settlements: settlements,
        editable: widget.editable,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    required this.split,
    required this.total,
    required this.contributions,
    required this.balance,
    required this.settlements,
    required this.editable,
  });

  final split_model.Split? split;
  final double total;
  final Map<String, double> contributions;
  final Map<String, double> balance;
  final List<Settlement> settlements;
  final bool editable;

  void _openTransactionModal(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddTransaction(
              split: split!,
            ),
          ),
        );
      },
    );
  }

  void _settleSplit(context) {
    DB().markSplit(split!.id).then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    if (split == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final dividedTotal = total / split!.contributors.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: _header(context, dividedTotal),
              ),
              Divider(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 10),
              _contributorsHeader(context),
              _contributorsList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
        DefaultTabController(
          length: 2,
          child: Expanded(
            child: Column(
              children: [
                TabBar(tabs: [
                  const Tab(text: "Transactions"),
                  if (editable) const Tab(text: "Settlement"),
                ]),
                Expanded(
                  child: TabBarView(
                    children: [
                      Scaffold(
                        body: _transactionList(),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        floatingActionButton: split == null || !editable
                            ? null
                            : FloatingActionButton(
                                onPressed: () => _openTransactionModal(context),
                                child: const Icon(
                                  Icons.add,
                                  size: 32,
                                ),
                              ),
                      ),
                      if (editable)
                        Scaffold(
                          body: _settlement(context),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          floatingActionButton: split == null || !editable
                              ? null
                              : FloatingActionButton(
                                  onPressed: () => _settleSplit(context),
                                  child: const Icon(
                                    Icons.check_circle_outline,
                                    size: 32,
                                  ),
                                ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _contributorsHeader(context) {
    return Row(
      children: [
        const Text(
          "Contributors",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const Spacer(),
        if (editable)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => _addContributorDialog(context),
            child: Icon(
              Icons.add,
              size: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
      ],
    );
  }

  Future<String?> _addContributorDialog(context) {
    TextEditingController controller = TextEditingController();

    Future<void> addContributor(String name) async {
      await DB().addContributor(split!.id, name);
    }

    void onConfirm() {
      addContributor(controller.text).then((_) {
        Navigator.of(context).pop();
      });
    }

    return showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Add a contributor',
                  style: TextStyle(
                    fontSize: 28,
                  )),
              const SizedBox(height: 30),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                controller: controller,
              ),
              const SizedBox(height: 30),
              ModalControls(
                onConfirm: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _settlement(context) {
    return ListView.separated(
      separatorBuilder: (ctx, i) => Divider(
        indent: 10,
        endIndent: 10,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      itemCount: settlements.length,
      itemBuilder: (ctx, i) {
        final settlement = settlements[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(children: [
            Text(
              "${settlement.from} -> ${settlement.to}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Text(
              "₹ ${settlement.amount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                color: theme.themeGreen,
              ),
            ),
          ]),
        );
      },
    );
  }

  ListView _transactionList() {
    return ListView.builder(
      itemCount: split!.transactions.length,
      itemBuilder: (ctx, i) => ListTile(
        title: Text(split!.transactions.toList()[i].description),
        subtitle: Text(
          split!.contributors[split!.transactions.toList()[i].contributor],
        ),
        trailing: Text(
          "₹ ${split!.transactions.toList()[i].amount}",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Row _header(BuildContext context, double dividedToal) {
    final day = split!.created.day;
    final month = split!.created.month;
    final year = split!.created.year;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                split!.title,
                style: const TextStyle(
                  fontSize: 36,
                ),
              ),
              Text(
                "$day/$month/$year",
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₹ ${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 26,
              ),
            ),
            Text(
              "₹ ${dividedToal.toStringAsFixed(2)} / person",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _contributorsList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: split!.contributors.length,
        itemBuilder: (ctx, i) {
          final contri = contributions[split!.contributors[i]] ?? 0;
          final bal = balance[split!.contributors[i]] ?? 0;
          return ListTile(
            title: Text(split!.contributors[i]),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₹ ${contri.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                bal == 0
                    ? const SizedBox()
                    : Text(
                        "₹ ${bal > 0 ? '+' : ''}${bal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: bal > 0 ? theme.themeRed : theme.themeGreen,
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
