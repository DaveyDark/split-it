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
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onTertiary,
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
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

class _Details extends StatefulWidget {
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

  @override
  State<_Details> createState() => _DetailsState();
}

class _DetailsState extends State<_Details> {
  String feedback = "";
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
              split: widget.split!,
            ),
          ),
        );
      },
    );
  }

  void _settleSplit(context) {
    DB().markSplit(widget.split!.id).then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.split == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final dividedTotal = widget.total / widget.split!.contributors.length;
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
              _contributorsList(context),
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
                  if (widget.editable) const Tab(text: "Settlement"),
                ]),
                Expanded(
                  child: TabBarView(
                    children: [
                      Scaffold(
                        body: _transactionList(),
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceBright,
                        floatingActionButton: widget.split == null ||
                                !widget.editable
                            ? null
                            : FloatingActionButton(
                                onPressed: () => _openTransactionModal(context),
                                child: const Icon(
                                  Icons.add,
                                  size: 32,
                                ),
                              ),
                      ),
                      if (widget.editable)
                        Scaffold(
                          body: _settlement(context),
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceBright,
                          floatingActionButton:
                              widget.split == null || !widget.editable
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 3,
      ),
      child: Row(
        children: [
          Text(
            "Contributors",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          const Spacer(),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: widget.editable
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _addContributorDialog(context),
                    child: Icon(
                      Icons.add,
                      size: 24,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _contributorsList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          _contributorsHeader(context),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
              color: Theme.of(context).colorScheme.surfaceTint,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.split!.contributors.length,
              itemBuilder: (ctx, i) {
                final contri =
                    widget.contributions[widget.split!.contributors[i]] ?? 0;
                final bal = widget.balance[widget.split!.contributors[i]] ?? 0;
                return ListTile(
                  title: Text(widget.split!.contributors[i]),
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
                                color:
                                    bal > 0 ? theme.themeRed : theme.themeGreen,
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _addContributorDialog(context) {
    TextEditingController controller = TextEditingController();
    setState(() {
      feedback = "";
    });

    Future<void> addContributor(String name) async {
      await DB().addContributor(widget.split!.id, name);
    }

    void onConfirm(StateSetter setState) {
      if (controller.text.isEmpty) {
        setState(() {
          feedback = "Name cannot be empty";
        });
        return;
      } else if (controller.text.length > 20) {
        setState(() {
          feedback = "Name too long";
        });
        return;
      } else if (widget.split!.contributors.contains(controller.text)) {
        setState(() {
          feedback = "Contributor already exists";
        });
        return;
      } else {
        setState(() {
          feedback = "";
        });
      }
      addContributor(controller.text).then((_) {
        Navigator.of(context).pop();
      });
    }

    return showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Dialog(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    feedback,
                    style: const TextStyle(
                      color: theme.themeRed,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ModalControls(
                  onConfirm: () => onConfirm(setState),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _settlement(context) {
    return ListView.separated(
      separatorBuilder: (ctx, i) => const SizedBox(
        height: 10,
      ),
      itemCount: widget.settlements.length + 1,
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return const Column(
            children: [
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "From",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Amount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "To",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        final i = idx - 1;
        final settlement = widget.settlements[i];
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: Text(
                  settlement.from,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(
                  "₹ ${settlement.amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: Text(
                  settlement.to,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  ListView _transactionList() {
    final transactionList = widget.split!.transactions.toList();
    final contributors = widget.split!.contributors;
    return ListView.builder(
        itemCount: widget.split!.transactions.length + 1,
        itemBuilder: (ctx, i) {
          if (i == 0) {
            return const SizedBox(height: 10);
          }
          final index = i - 1;
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: ListTile(
              title: Text(
                widget.split!.transactions.toList()[index].description,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                contributors[transactionList[index].contributor],
              ),
              trailing: Text(
                "₹ ${transactionList[index].amount}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        });
  }

  Row _header(BuildContext context, double dividedToal) {
    final day = widget.split!.created.day;
    final month = widget.split!.created.month;
    final year = widget.split!.created.year;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.split!.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$day/$month/$year",
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₹ ${widget.total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
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
}
