import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/global/session_controller.dart';
import '../app/my_app.dart';
import '../app/pages/error_view.dart';
import '../app/pages/home/home_view.dart';
import '../app/pages/home/product_view.dart';
import '../app/pages/home/widgets/scaffold.dart';
import '../app/pages/profile_view.dart';
import '../app/pages/sign_in_view.dart';
import '../app/routes/routes.dart';

mixin RouterMixin on State<MyApp> {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter? _router;

  GoRouter get router {
    _router ??= GoRouter(
      initialLocation: '/',
      navigatorKey: rootNavigatorKey,
      errorBuilder: (_, state) => ErrorView(
        state: state,
      ),
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return HomeScaffold(
              child: child,
            );
          },
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
                final id = state.pathParameters['id']!;
                return ProductView(
                  id: int.parse(id),
                );
              },
              redirect: (context, state) => authGuard(
                context: context,
                state: state,
                callbackURL: '/product/${state.pathParameters['id']}',
              ),
            ),
          ],
        ),
        GoRoute(
          name: Routes.signIn,
          path: '/sign-in',
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, state) {
            final callbackURL = state.uri.queryParameters['callbackURL'];
            return SignInView(
              callbackUrl: callbackURL ?? '/',
            );
          },
          redirect: (context, state) {
            final isSignedIn = context.read<SessionController>().isSignedIn;
            if (isSignedIn) {
              return '/';
            }
            return null;
          },
        ),
        GoRoute(
          name: Routes.profile,
          path: '/profile',
          parentNavigatorKey: rootNavigatorKey,
          builder: (_, __) => const ProfileView(),
          redirect: (context, state) => authGuard(
            context: context,
            state: state,
            callbackURL: '/profile',
          ),
        ),
      ],
    );
    return _router!;
  }
}

FutureOr<String?> authGuard({
  required BuildContext context,
  required GoRouterState state,
  required String callbackURL,
}) async {
  final isSignedIn = context.read<SessionController>().isSignedIn;
  if (isSignedIn) {
    return null;
  }
  return '/sign-in?callbackURL=$callbackURL';
}
