import 'package:flutter/material.dart';
import 'package:pokenav/features/pokemon/data/constants.dart';
import 'package:pokenav/features/pokemon/model/pokemon.dart';
import 'package:pokenav/features/pokemon/view/widgets/stat_pill.dart';
import 'package:pokenav/shared/utils/string_utils.dart';

class PokemonCard extends StatefulWidget {
  const PokemonCard(this.pokemon, {super.key});

  final Pokemon pokemon;

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedSize(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: Card(
          elevation: 2,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              setState(() {
                print('Pressed ${widget.pokemon.name}');
                _isExpanded = !_isExpanded;
              });
            },
            child: SizedBox(
              height: _isExpanded ? 170 : 100,
              child: Stack(
                children: [
                  // Sky backgorund
                  Positioned.fill(
                    child: Container(
                      color: Colors.lightBlue[100],
                      // color: const Color(0xFF87CEEB),
                    ),
                  ),

                  // Grass layer
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'backgrounds/card_grass.png',
                      fit: BoxFit.cover,
                      height: 50,
                      color: Colors.white.withAlpha(120),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),

                  // Card content
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  (widget.pokemon.imageUrl == null ||
                                      widget.pokemon.imageUrl!.isEmpty)
                                  ? Image.asset('icons/pikachu_dark.png')
                                  : FadeInImage.assetNetwork(
                                      placeholder: 'icons/pikachu_dark.png',
                                      image: widget.pokemon.imageUrl!,
                                      width: 64,
                                    ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  widget.pokemon.name.capitalize(),
                                  style: TextStyle(
                                    fontFamily: 'Game Paused',
                                    fontSize: 24,
                                    color: Colors.blueGrey[800],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 130.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 2.0,
                                      ),
                                      child: Text(
                                        (widget.pokemon.types != null &&
                                                widget.pokemon.types!.length >
                                                    1)
                                            ? 'Types'
                                            : 'Type',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (widget.pokemon.types == null ||
                                            widget.pokemon.types!.isEmpty)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0,
                                            ),
                                            child: Image.asset(
                                              'types/unknown.png',
                                              height: 24.0,
                                            ),
                                          )
                                        else
                                          for (var type
                                              in widget.pokemon.types!)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 1.0,
                                                  ),
                                              child: Image.asset(
                                                'types/${type.name}.png',
                                                height: 24.0,
                                              ),
                                            ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_isExpanded)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 30,
                            children: [
                              StatPill(
                                stat: StatTypes.hp,
                                value: widget.pokemon.hp,
                                // value: 9999,
                              ),
                              StatPill(
                                stat: StatTypes.attack,
                                value: widget.pokemon.attack,
                                // value: 9999,
                              ),
                              StatPill(
                                stat: StatTypes.defense,
                                value: widget.pokemon.defense,
                                // value: 9999,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
