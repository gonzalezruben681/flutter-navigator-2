import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/global/session_controller.dart';
import '../app/my_app.dart';
import '../app/pages/error_view.dart';
import '../app/pages/home_view.dart';
import '../app/pages/product_view.dart';
import '../app/pages/profile_view.dart';
import '../app/pages/sign_in_view.dart';
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
        },
        redirect: (context, state) => authGuard(
          context: context,
          state: state,
          callbackUrl: '/product/${state.pathParameters['id']}',
        ),
      ),
      GoRoute(
        name: Routes.signIn,
        path: '/sign_in',
        builder: (_, state) {
          final callback = state.pathParameters['callbackUrl'];
          return SignInView(callbackUrl: callback ?? '/');
        },
        redirect: (context, state) async {
          final isSignedIn = context.read<SessionController>().isSignedIn;
          if (isSignedIn) {
            return '/'; // Redirect to home if already signed in
          }
          return null;
        },
      ),
      GoRoute(
        name: Routes.profile,
        path: '/profile',
        builder: (_, __) => const ProfileView(), // Placeholder for profile view
        redirect: (context, state) => authGuard(
          context: context,
          state: state,
          callbackUrl: '/profile',
        ),
      ),
    ],
  );
  GoRouter get router => _router;
}

FutureOr<String?> authGuard({
  required BuildContext context,
  required GoRouterState state,
  required String callbackUrl,
}) async {
  final isSignedIn = context.read<SessionController>().isSignedIn;
  if (isSignedIn) {
    return null; // User is signed in, allow access
  }
  return '/sign_in?callbackUrl=$callbackUrl'; // Redirect to sign-in if not signed in

}
