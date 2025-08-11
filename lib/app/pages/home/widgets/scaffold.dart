import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/routes.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key, required this.child});

  final Widget child;

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  final counter = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        counter.value++; // Initialize the counter
      },
    );
  }

// Asegura que el widget se reconstruya si es necesario
  @override
  void didUpdateWidget(covariant HomeScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        counter.value++;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: ValueListenableBuilder<int>(
            valueListenable: counter,
            builder: (_, value, __) {
              return AppBar(
                leading: value > 0 && GoRouter.of(context)
        .canPop() // Asegura que el botón de retroceso funcione correctamente
                    ? BackButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                      )
                    : null, // Muestra el botón de retroceso solo si es necesario
                actions: [
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).goNamed(Routes.profile);
                    },
                    icon: const Icon(Icons.person),
                  ),
                ],
              );
            }),
      ),
      body: widget.child,
    );
  }
}
