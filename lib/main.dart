import 'package:flutter/material.dart';
import 'package:pokenav/core/theme/app_text_theme.dart';
import 'package:pokenav/features/pokemon/data/pokemon_api_service.dart';
import 'package:pokenav/features/pokemon/data/pokemon_repository.dart';
import 'package:pokenav/features/pokemon/view/screens/pokemon_list_screen.dart';

void main() {
  runApp(const PokeNavApp());
}

class PokeNavApp extends StatelessWidget {
  const PokeNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    // var service = PokeApiService();
    // service.getPokemonList();

    // final repo = PokemonRepository();
    // repo.getPokemon('charizard').then((pokemon) => print(pokemon));
    // repo.getPokemon('arceus').then((pokemon) => print(pokemon));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: AppTextTheme.textTheme),
      home: PokemonListLayout(),
    );
  }
}
