import 'package:flutter/material.dart';

import 'package:km_recipes/src/app.dart';
import 'package:km_recipes/src/state_widget.dart';

// - StateWidget incl. state data
//    - RecipesApp
//        - All other widgets which are able to access the data
void main() => runApp(new StateWidget(
      child: new RecipesApp(),
    ));
