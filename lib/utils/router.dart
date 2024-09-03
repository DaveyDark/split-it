import 'package:go_router/go_router.dart';
import 'package:split_it/screens/split_detail.dart';
import 'package:split_it/screens/splits.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (ctx, state) => const Splits(),
    ),
    GoRoute(
      path: '/splits/edit/:id',
      builder: (ctx, state) => SplitDetail(
        id: state.pathParameters['id']!,
        editable: true,
      ),
    ),
    GoRoute(
      path: '/splits/view/:id',
      builder: (ctx, state) => SplitDetail(
        id: state.pathParameters['id']!,
        editable: false,
      ),
    ),
  ],
);
