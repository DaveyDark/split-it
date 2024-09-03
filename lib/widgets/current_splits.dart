import 'package:flutter/material.dart';
import 'package:split_it/services/database.dart';
import 'package:split_it/widgets/split_card.dart';

class CurrentSplits extends StatefulWidget {
  const CurrentSplits({
    super.key,
  });

  @override
  State<CurrentSplits> createState() => _CurrentSplitsState();
}

class _CurrentSplitsState extends State<CurrentSplits> {
  List? splits;

  Future<void> _fetchSplits() async {
    final activeSplits = await DB().getActiveSplits();
    setState(() {
      splits = activeSplits;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSplits();

    // Subscribe to changes
    DB().watchSplits().listen((_) {
      _fetchSplits();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (splits == null) {
      return const _PageWrapper(
        child: CircularProgressIndicator(),
      );
    }
    if (splits!.isEmpty) {
      return const _PageWrapper(
        child: Center(
          child: Text("No splits found"),
        ),
      );
    }
    return _PageWrapper(
      child: ListView.separated(
        itemCount: splits!.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                const SizedBox(height: 10),
                SplitCard(
                  splitId: splits![index].id,
                  onTapUrl: "/splits/edit/${splits![index].id}",
                ),
              ],
            );
          }
          return SplitCard(
            splitId: splits![index].id,
            onTapUrl: "/splits/edit/${splits![index].id}",
          );
        },
        padding: const EdgeInsets.only(
          bottom: 100,
        ),
      ),
    );
  }
}

class _PageWrapper extends StatelessWidget {
  final Widget child;
  const _PageWrapper({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
