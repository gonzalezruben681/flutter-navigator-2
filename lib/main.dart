import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/global/session_controller.dart';
import 'app/my_app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding
      .ensureInitialized(); // siempre se debe inicializar antes de usar SharedPreferences
  final preferences = await SharedPreferences.getInstance();
  setPathUrlStrategy(); // Esto es para que las rutas funcionen sin el #
  runApp(
    Provider<SessionController>(
        create: (_) => SessionController(preferences), child: const MyApp()),
  );
}
