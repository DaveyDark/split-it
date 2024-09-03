import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:split_it/services/theme_provider.dart' as tp;

class SplitItAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SplitItAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(tp.themeProvider);
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      leading: Image.asset('assets/splitit_logo_dark.png'),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/splitit_banner.png',
            height: kToolbarHeight,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          onPressed: () => ref.read(tp.themeProvider.notifier).toggleTheme(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
