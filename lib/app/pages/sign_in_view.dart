import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../global/session_controller.dart';

class SignInView extends StatelessWidget {
  const SignInView({
    super.key,
    required this.callbackUrl,
  });
  final String callbackUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<SessionController>().setSignedIn(true);
            GoRouter.of(context)
                .go(callbackUrl); // Navigate to home after sign-in
          },
          child: const Text('Iniciar Sesión'),
        ),
      ),
    );
  }
}
