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
    if (mounted) {
      setState(() {
        split = s;
        total = t;
      });
    }
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      split!.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  splitDate(context, day, month, year),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5,
                ),
                child: splitParams(
                  context,
                  dividedToal,
                  total,
                ),
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
        splitStat(
          context: context,
          icon: Icons.assignment_outlined,
          value: total.toStringAsFixed(2),
        ),
        const SizedBox(width: 10),
        splitStat(
          context: context,
          icon: Icons.payments_outlined,
          value: dividedToal.toStringAsFixed(2),
        ),
        const SizedBox(width: 10),
        splitStat(
          context: context,
          icon: Icons.people_outline,
          value: split!.contributors.length.toString(),
        ),
      ],
    );
  }

  Widget borderBox(BuildContext context, Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 3,
            spreadRadius: 0.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget splitStat({
    required BuildContext context,
    required IconData icon,
    required String value,
  }) {
    return Expanded(
      child: borderBox(
        context,
        Row(
          children: [
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Container splitDate(BuildContext context, int day, int month, int year) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.25),
        borderRadius: BorderRadius.circular(200),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 12,
      ),
      child: Text(
        "$day/$month/$year",
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
