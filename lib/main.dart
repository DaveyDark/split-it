import 'package:flutter/material.dart';
import 'package:split_it/utils/router.dart';
import 'package:split_it/utils/theme.dart';

import 'services/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB().init();
  runApp(const SplitIt());
}

class SplitIt extends StatelessWidget {
  const SplitIt({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SplitIt',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
    );
  }
}
