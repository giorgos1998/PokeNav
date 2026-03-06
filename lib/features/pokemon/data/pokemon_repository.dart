import 'package:pokenav/features/pokemon/data/constants.dart';
import 'package:pokenav/features/pokemon/data/pokemon_api_service.dart';
import 'package:pokenav/features/pokemon/model/pokemon.dart';

class PokemonRepository {
  final apiService = PokeApiService();

  Future<List<Pokemon>> getPokemonNamesFromSearch({
    required String searchTerm,
    required PokemonType type,
    int amount = 10,
    int existing = 0,
  }) async {
    final pokemonJson = await apiService.getPokemonsFromType(type);
    final pokemons = List<Pokemon>.from(
      pokemonJson['pokemon'].map(
        (entry) => Pokemon(name: entry['pokemon']['name']),
      ),
    );

    return pokemons
        .skip(existing)
        .where((pokemon) => pokemon.name.contains(searchTerm))
        .take(amount)
        .toList();
  }

  Future<List<Pokemon>> getPokemonNamesFromType(
    PokemonType type, {
    int amount = 10,
    int existing = 0,
  }) async {
    final pokemonJson = await apiService.getPokemonsFromType(type);
    final pokemons = List<Pokemon>.from(
      pokemonJson['pokemon'].map(
        (entry) => Pokemon(name: entry['pokemon']['name']),
      ),
    );

    return pokemons.skip(existing).take(amount).toList();
  }

  Future<List<Pokemon>> getPokemonNames({int? amount, int? existing}) async {
    final pokemonJson = await apiService.getPokemonList(
      limit: amount,
      offset: existing,
    );

    return List<Pokemon>.from(
      pokemonJson['results'].map((result) => Pokemon(name: result['name'])),
    );
  }

  Future<Pokemon> getPokemon(String name) async {
    final pokemonJson = await apiService.getPokemonInfo(name);

    return Pokemon(
      name: name,
      types: _getTypes(pokemonJson),
      hp: _getStat(stat: 'hp', json: pokemonJson),
      attack: _getStat(stat: 'attack', json: pokemonJson),
      defense: _getStat(stat: 'defense', json: pokemonJson),
      imageUrl: _getImageUrl(pokemonJson),
    );
  }

  int _getStat({required String stat, required dynamic json}) {
    return json['stats'].firstWhere(
      (element) => element['stat']['name'] == stat,
    )['base_stat'];
  }

  List<PokemonType>? _getTypes(dynamic json) {
    final types = List<PokemonType>.from(
      json['types']
          .map((type) => type['type']['name'])
          .map((typeStr) {
            try {
              return PokemonType.values.byName(typeStr);
            } catch (e) {
              // Type is not in the 10 types in the enum.
              return null;
            }
          })
          .where((type) => type != null),
    );

    if (types.isEmpty) {
      return null;
    }
    return types;
  }

  String? _getImageUrl(dynamic json) {
    return json['sprites']['versions']['generation-iii']['emerald']['front_default'] ??
        json['sprites']['front_default'];
  }
}
