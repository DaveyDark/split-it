import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:split_it/services/database.dart';
import 'package:split_it/models/split.dart' as split_model;

class SplitCard extends StatefulWidget {
  const SplitCard({super.key, required this.splitId, required this.onTapUrl});

  final int splitId;
  final String onTapUrl;

  @override
  State<SplitCard> createState() => _SplitCardState();
}

class _SplitCardState extends State<SplitCard> {
  split_model.Split? split;
  double total = 0;

  void _fetchSplit() async {
    final s = await DB().getSplit(widget.splitId);
    final t = await DB().getTotal(widget.splitId);
    setState(() {
      split = s;
      total = t;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSplit();
    // Subscribe to changes
    DB().watchSplit(widget.splitId).listen((_) {
      _fetchSplit();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (split == null) {
      return const CircularProgressIndicator();
    }
    final dividedToal = total / split!.contributors.length;
    final day = split!.created.day;
    final month = split!.created.month;
    final year = split!.created.year;
    return GestureDetector(
      onTap: () => context.push(widget.onTapUrl),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              splitDate(context, day, month, year),
              const SizedBox(height: 10),
              Text(
                split!.title,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: splitParams(context, dividedToal, total),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row splitParams(BuildContext context, double dividedToal, double total) {
    return Row(
      children: [
        splitStat(context, Icons.receipt_long, total.toStringAsFixed(2)),
        const Spacer(),
        splitStat(
            context, Icons.currency_rupee, dividedToal.toStringAsFixed(2)),
        Expanded(
          child: VerticalDivider(
            color: Colors.white,
            width: 2,
            thickness: 2,
          ),
        ),
        splitStat(context, Icons.people, split!.contributors.length.toString()),
      ],
    );
  }

  Row splitStat(BuildContext context, IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 28,
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Container splitDate(BuildContext context, int day, int month, int year) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(200),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Text("$day/$month/$year"),
    );
  }
}
