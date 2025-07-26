import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../app/my_app.dart';
import '../app/pages/error_view.dart';
import '../app/pages/home_view.dart';
import '../app/pages/product_view.dart';
import '../app/routes/routes.dart';

mixin RouterMixin on State<MyApp> {
  final _router = GoRouter(
    initialLocation: '/',
    errorBuilder: (_, state) => ErrorView(state: state),
    routes: [
      GoRoute(
        name: Routes.home,
        path: '/',
        builder: (_, __) => const HomeView(),
      ),
      GoRoute(
          name: Routes.product,
          path: '/product/:id',
          builder: (_, state) {
            return ProductView(id: int.parse(state.pathParameters['id']!));
          })
    ],
  );
  GoRouter get router => _router;
}
