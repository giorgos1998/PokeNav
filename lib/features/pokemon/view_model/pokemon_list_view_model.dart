import 'package:flutter/material.dart';
import 'package:pokenav/features/pokemon/data/constants.dart';
import 'package:pokenav/features/pokemon/data/pokemon_repository.dart';
import 'package:pokenav/features/pokemon/model/pokemon.dart';

class PokemonListViewModel extends ChangeNotifier {
  static const _pokemonPerPage = 15;

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
    print('Applying filter: ${type?.name}');
    activeFilter = type;
    searchEnabled = activeFilter != null ? true : false;
    notifyListeners();

    noMoreResults = false;
    _visiblePokemons.clear();
    nextPage();
  }

  void searchPokemon(String text) {
    searchTerm = text.toLowerCase();
    print('Searching for: $searchTerm');

    noMoreResults = false;
    _visiblePokemons.clear();
    nextPage();
  }

  Future<void> _loadPokemonNames(int amount) async {
    List<Pokemon> page;

    isLoadingNames = true;
    notifyListeners();

    print('($activeFilter, $searchEnabled, ${searchTerm?.isEmpty})');
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
        print('Should be here for searching');
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

    print('Finished loading names, count: ${_visiblePokemons.length}');

    isLoadingNames = false;
    notifyListeners();
  }

  Future<void> _loadPokemonDetails() async {
    isLoadingDetails = true;
    notifyListeners();

    var emptyDetails = _visiblePokemons.where(
      (pokemon) => pokemon.imageUrl == null,
    );

    // print('Pokemon without details: ${emptyDetails.length}');

    for (var pokemon in emptyDetails) {
      try {
        final index = _visiblePokemons.indexWhere(
          (p) => p.name == pokemon.name,
        );
        _visiblePokemons[index] = (await _repository.getPokemon(pokemon.name));
      } catch (e) {
        print('Error when parsing details from: ${pokemon.name}');
      }
    }
    // print('Finished loading details, count: ${_visiblePokemons.length}');

    isLoadingDetails = false;
    notifyListeners();
  }
}
