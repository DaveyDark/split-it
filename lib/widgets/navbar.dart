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
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 50,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(200),
      ),
      child: NavigationBar(
        onDestinationSelected: onItemTapped,
        selectedIndex: currentIndex,
        backgroundColor: Colors.transparent,
        destinations: [
          FloatingActionButton(
            onPressed: () => onItemTapped(0),
            shape: const CircleBorder(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            tooltip: "Current Splits",
            child: Icon(
              Icons.receipt,
              size: 30,
              color: currentIndex == 0
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            height: kToolbarHeight,
            child: IconButton(
              onPressed: () => showAddSplitModal(context),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 40,
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () => onItemTapped(2),
            shape: const CircleBorder(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            tooltip: "Current Splits",
            focusColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            child: Icon(
              Icons.watch_later,
              size: 30,
              color: currentIndex == 2
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
