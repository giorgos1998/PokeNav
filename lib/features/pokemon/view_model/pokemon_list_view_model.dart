import 'package:flutter/material.dart';
import 'package:pokenav/features/pokemon/data/constants.dart';
import 'package:pokenav/features/pokemon/data/pokemon_repository.dart';
import 'package:pokenav/features/pokemon/model/pokemon.dart';

class PokemonListViewModel extends ChangeNotifier {
  static const _pokemonPerPage = 10;

  final List<Pokemon> _visiblePokemons = [];
  final PokemonRepository _repository = PokemonRepository();

  bool isLoadingDetails = false;
  bool isLoadingNames = false;
  bool searchEnabled = false;
  bool noMoreResults = false;
  PokemonType? activeFilter;
  String? searchTerm;

  PokemonListViewModel() {
    nextPage();
  }

  List<Pokemon> get pokemons {
    print('Visible pokemons count: ${_visiblePokemons.length}');
    return _visiblePokemons;
  }

  Future<void> nextPage() async {
    await _loadPokemonNames(_pokemonPerPage);
    await _loadPokemonDetails();
  }

  void applyFilter(PokemonType? type) {
    activeFilter = type;
    searchEnabled = activeFilter != null ? true : false;
    searchTerm = null;
    notifyListeners();

    noMoreResults = false;
    _visiblePokemons.clear();
    nextPage();
  }

  void searchPokemon(String text) {
    searchTerm = text.toLowerCase();

    noMoreResults = false;
    _visiblePokemons.clear();
    nextPage();
  }

  Future<void> _loadPokemonNames(int amount) async {
    List<Pokemon> page;

    isLoadingNames = true;
    notifyListeners();

    switch ((activeFilter, searchEnabled, searchTerm?.isEmpty)) {
      case (null, _, _):
        page = await _repository.getPokemonNames(
          amount: amount,
          existing: _visiblePokemons.length,
        );
        break;
      case (_, false, _):
      case (_, true, null || true):
        page = await _repository.getPokemonNamesFromType(
          activeFilter!,
          amount: amount,
          existing: _visiblePokemons.length,
        );
        break;
      case (_, true, false):
        page = await _repository.getPokemonNamesFromSearch(
          searchTerm: searchTerm!,
          type: activeFilter!,
          amount: amount,
          existing: _visiblePokemons.length,
        );
        break;
    }

    if (page.isEmpty) {
      noMoreResults = true;
    }

    _visiblePokemons.addAll(page);

    isLoadingNames = false;
    notifyListeners();
  }

  Future<void> _loadPokemonDetails() async {
    isLoadingDetails = true;
    notifyListeners();

    var emptyDetails = _visiblePokemons.where(
      (pokemon) => pokemon.imageUrl == null,
    );

    for (var pokemon in emptyDetails) {
      final index = _visiblePokemons.indexWhere((p) => p.name == pokemon.name);
      _visiblePokemons[index] = (await _repository.getPokemon(pokemon.name));
    }

    isLoadingDetails = false;
    notifyListeners();
  }
}
