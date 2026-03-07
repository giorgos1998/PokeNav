import 'package:flutter/material.dart';
import 'package:pokenav/core/theme/app_text_theme.dart';
import 'package:pokenav/features/pokemon/view/screens/pokemon_list_screen.dart';

void main() {
  runApp(const PokeNavApp());
}

class PokeNavApp extends StatelessWidget {
  const PokeNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: AppTextTheme.textTheme),
      home: PokemonListLayout(),
    );
  }
}
