// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'pages/home_view.dart';
import 'pages/product_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final delegate = MyRouterDelegate(
    pages: [
      MyPage((_) => HomeView(), path: '/'), // Define una página con su builder
      MyPage(
        (data) => ProductView(id: int.parse(data['id']!)),
        path: '/product/:id',
      ), // Define otra página con su builder
    ],
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: delegate, // sirve para definir la navegación
      routeInformationParser:
          MyRouteInformationParser(), // sirve para parsear la información de la ruta, si estamos en una ruta específica
    );
  }
}

// Clase para definir una página con su builder
class MyPage {
  final String path;
  final Widget Function(Map<String, String> data) builder;

  MyPage(this.builder, {required this.path});
}

// este es el router delegate, que es el encargado de construir la navegación
class MyRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final List<MyPage> pages;
  late List<Page> _navigatorPages;

  MyRouterDelegate({required this.pages}) {
    final initialPage = pages.firstWhere(
      (page) => page.path == '/',
    );
    _navigatorPages = [
      MaterialPage(
        name: '/',
        child: initialPage.builder(
          {},
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onDidRemovePage: (page) {
        _navigatorPages.removeWhere((p) => p.name == page.name);
        notifyListeners(); // Notifica a los listeners para que se reconstruya la UI
      },
      // ignore: prefer_const_literals_to_create_immutables
      pages: _navigatorPages,
    );
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    final path = configuration.path;
    final data = <String, String>{};
    final index = pages.indexWhere((e) {
      if (e.path == path) {
        return true;
      }
      // Verifica si la ruta contiene un parámetro
      if (e.path.contains('/:')) {
        final lastIndex = e.path.lastIndexOf('/:');
    
        // Si la ruta contiene un parámetro, verifica si la ruta comienza con la subcadena antes del parámetro
        final subString = e.path.substring(
            0, lastIndex); // Obtiene la parte de la ruta antes del parámetro
        // Verifica si la ruta comienza con esa subcadena
        if (path.startsWith(subString)) {
          // Extrae el valor del parámetro
          final key = e.path.substring(lastIndex + 2, e.path.length); // Obtiene el nombre del parámetro
          final value = path.substring(lastIndex + 1, path.length); // Obtiene el valor del parámetro
          data[key] = value; // Agrega el parámetro al mapa de datos
          return true;
        }
      }
      return false;
    });
    // Si se encuentra la ruta, se agrega a las páginas del navegador
    if (index != -1) {
      _navigatorPages = [
        ..._navigatorPages,
        MaterialPage(
          name: path,
          child: pages[index].builder(data),
        ),
      ];
      notifyListeners(); // Notifica a los listeners para que se reconstruya la UI
    }
  }

// Este método se llama cuando se navega hacia atrás
  @override
  Uri? get currentConfiguration => Uri.parse(_navigatorPages.last.name ?? '');

// Este método se llama para obtener la clave del navegador
  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();
}

// este es el route information parser, que es el encargado de parsear la información de la ruta
class MyRouteInformationParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) {
    // aquí se puede parsear la información de la ruta, por ejemplo, si se quiere navegar a una ruta específica
    return Future.value(Uri.parse(routeInformation.location));
  }

  @override
  RouteInformation restoreRouteInformation(Uri configuration) {
    // aquí se puede restaurar la información de la ruta, por ejemplo, si se quiere navegar a una ruta específica
    return RouteInformation(location: configuration.toString());
  }
}
