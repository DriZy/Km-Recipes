import 'package:flutter/material.dart';

import 'package:km_recipes/src/ui/screens/recipes_home.dart';
import 'package:km_recipes/src/ui/screens/recipes_login.dart';
import 'package:km_recipes/src/ui/recipes_theme.dart';

class RecipesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      theme: buildTheme(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}