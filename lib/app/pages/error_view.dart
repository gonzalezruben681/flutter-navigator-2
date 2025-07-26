import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/routes.dart';

class ErrorView extends StatelessWidget {
  final GoRouterState state;
  const ErrorView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // sirve para centrar el contenido
          children: [
            Text(
              'Error: ${state.error}',
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).goNamed(Routes.home); // Navigate to home
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
