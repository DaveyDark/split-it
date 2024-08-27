import 'package:flutter/material.dart';
import 'package:split_it/widgets/appbar.dart';
import 'package:split_it/widgets/current_splits.dart';
import 'package:split_it/widgets/navbar.dart';
import 'package:split_it/widgets/splits_history.dart';

class Splits extends StatefulWidget {
  const Splits({super.key});

  @override
  State<Splits> createState() => _SplitsState();
}

class _SplitsState extends State<Splits> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SplitItAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: switch (_currentIndex) {
              0 => const CurrentSplits(),
              1 => const SplitsHistory(),
              _ => const Center(child: Text("Page not found")),
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Navbar(
              onItemTapped: _onItemTapped,
              currentIndex: _currentIndex,
            ),
          ),
        ],
      ),
    );
  }
}
