import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pokenav/features/pokemon/data/constants.dart';

class PokeApiService {
  Future<dynamic> getPokemonList({int? limit, int? offset}) async {
    final url = Uri.https('pokeapi.co', '/api/v2/pokemon', {
      'limit': limit.toString(),
      'offset': offset.toString(),
    });
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw HttpException(
        'Failed to get Pokemon list, status code: ${response.statusCode}',
      );
    }

    return jsonDecode(response.body);
  }

  Future<dynamic> getPokemonInfo(String name) async {
    final url = Uri.https('pokeapi.co', '/api/v2/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw HttpException(
        'Failed to get Pokemon, status code: ${response.statusCode}',
      );
    }

    return jsonDecode(response.body);
  }

  Future<dynamic> getPokemonsFromType(PokemonType type) async {
    final url = Uri.https('pokeapi.co', '/api/v2/type/${type.name}');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw HttpException(
        'Failed to get Pokemons from type, status code: ${response.statusCode}',
      );
    }

    return jsonDecode(response.body);
  }
}
