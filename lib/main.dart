import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:split_it/services/theme_provider.dart';
import 'package:split_it/utils/router.dart';
import 'package:split_it/utils/theme.dart';

import 'services/database.dart';

Future<void> main() async {
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await DB().init();
  FlutterNativeSplash.remove();
  runApp(
    const ProviderScope(
      child: SplitIt(),
    ),
  );
}

class SplitIt extends ConsumerWidget {
  const SplitIt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      title: 'SplitIt',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
