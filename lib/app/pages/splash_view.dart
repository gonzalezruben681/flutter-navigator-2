import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr, // Asegura que el texto se muestre de izquierda a derecha
      child: Material(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, //que no ocupe todo el espacio posible
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Cargando...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
              ],
            ),
          ),
        ),
    );
  }
}