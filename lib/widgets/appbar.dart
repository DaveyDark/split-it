import 'package:flutter/material.dart';

class SplitItAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SplitItAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/splitit_banner.png',
            height: kToolbarHeight,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
