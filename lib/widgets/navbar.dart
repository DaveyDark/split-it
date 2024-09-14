import 'package:flutter/material.dart';
import 'package:split_it/widgets/add_split.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.onItemTapped,
    required this.currentIndex,
  });

  final void Function(int index) onItemTapped;
  final int currentIndex;

  void showAddSplitModal(BuildContext context) {
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
            child: const AddSplit(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 20,
        ),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(200),
        ),
        child: NavigationBar(
          onDestinationSelected: onItemTapped,
          selectedIndex: currentIndex,
          backgroundColor: Colors.transparent,
          destinations: [
            IconButton(
              onPressed: () => onItemTapped(0),
              tooltip: "Current Splits",
              icon: Icon(
                Icons.receipt,
                size: currentIndex == 0 ? 35 : 30,
                color: currentIndex == 0
                    ? Theme.of(context).colorScheme.onTertiary
                    : Theme.of(context).colorScheme.surface,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => showAddSplitModal(context),
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 35,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () => onItemTapped(1),
              shape: const CircleBorder(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              tooltip: "Current Splits",
              focusColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Icon(
                Icons.watch_later,
                size: currentIndex == 1 ? 35 : 30,
                color: currentIndex == 1
                    ? Theme.of(context).colorScheme.onTertiary
                    : Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
