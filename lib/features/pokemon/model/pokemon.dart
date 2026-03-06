import 'package:pokenav/features/pokemon/data/constants.dart';

class Pokemon {
  final String name;
  final List<PokemonType>? types;
  final int? hp;
  final int? attack;
  final int? defense;
  final String? imageUrl;

  Pokemon({
    required this.name,
    this.types,
    this.hp,
    this.attack,
    this.defense,
    this.imageUrl,
  });

  @override
  String toString() {
    return '$name:\ntypes: $types\nHP: $hp\nATK: $attack\nDEF: $defense';
  }
}
