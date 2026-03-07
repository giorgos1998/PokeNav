import 'package:pokenav/features/pokemon/data/constants.dart';

class Pokemon {
  final String name;
  String? displayName;
  final List<PokemonType>? types;
  final int? hp;
  final int? attack;
  final int? defense;
  final String? imageUrl;

  Pokemon({
    required this.name,
    this.displayName,
    this.types,
    this.hp,
    this.attack,
    this.defense,
    this.imageUrl,
  });

  @override
  String toString() {
    return '''$name ($displayName):
 - types: $types
 - HP: $hp
 - ATK: $attack
 - DEF: $defense
 - Image: $imageUrl''';
  }
}
