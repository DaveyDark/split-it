import 'package:flutter/material.dart';
import 'package:split_it/services/database.dart';
import 'package:split_it/widgets/split_card.dart';

class SplitsHistory extends StatefulWidget {
  const SplitsHistory({
    super.key,
  });

  @override
  State<SplitsHistory> createState() => _SplitsHistoryState();
}

class _SplitsHistoryState extends State<SplitsHistory> {
  List? splits;

  Future<void> _fetchSplits() async {
    if (!mounted) return;
    final activeSplits = await DB().getSettledSplits();
    setState(() {
      splits?.clear();
      splits = activeSplits;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSplits();

    DB().watchSplits().listen((_) {
      _fetchSplits();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (splits == null) {
      return const CircularProgressIndicator();
    }
    if (splits!.isEmpty) {
      return const Center(
        child: Text("No splits found"),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: splits!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            return SplitCard(
              key: ValueKey(splits![index].id),
              splitId: splits![index].id,
              onTapUrl: "/splits/view/${splits![index].id}",
            );
          },
        ),
      ),
    );
  }
}
