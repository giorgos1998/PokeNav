import 'package:flutter/material.dart';
import 'package:pokenav/features/pokemon/data/constants.dart';
import 'package:pokenav/features/pokemon/model/pokemon.dart';
import 'package:pokenav/features/pokemon/view/widgets/stat_pill.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedSize(
        duration: Duration(seconds: 1),
        // curve: Curves.fastOutSlowIn,
        curve: Curves.elasticOut,
        child: Card(
          elevation: 4,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: SizedBox(
              height: _isExpanded ? 170 : 100,
              child: Stack(
                children: [
                  // Sky backgorund
                  Positioned.fill(
                    child: Container(color: Colors.lightBlue[100]),
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
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        // Main card contents.
                        Row(
                          children: [
                            // Pokemon image.
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  (widget.pokemon.imageUrl == null ||
                                      widget.pokemon.imageUrl!.isEmpty)
                                  ? Image.asset(
                                      'icons/pikachu_dark.png',
                                      width: 64,
                                    )
                                  : FadeInImage.assetNetwork(
                                      placeholder: 'icons/pikachu_dark.png',
                                      image: widget.pokemon.imageUrl!,
                                      width: 64,
                                    ),
                            ),

                            // Pokemon name.
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  widget.pokemon.displayName ??
                                      widget.pokemon.name,
                                  style: textTheme.titleLarge,
                                ),
                              ),
                            ),

                            // Pokemon types.
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 130.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 2,
                                  children: [
                                    Text(
                                      (widget.pokemon.types != null &&
                                              widget.pokemon.types!.length > 1)
                                          ? 'Types'
                                          : 'Type',
                                      style: textTheme.bodyMedium,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 2,
                                      children: [
                                        if (widget.pokemon.types == null ||
                                            widget.pokemon.types!.isEmpty)
                                          Image.asset(
                                            'types/unknown.png',
                                            height: 24.0,
                                          )
                                        else
                                          for (var type
                                              in widget.pokemon.types!)
                                            Image.asset(
                                              'types/${type.name}.png',
                                              height: 24.0,
                                            ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Extra stats for expanded card.
                        if (_isExpanded)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 30,
                            children: [
                              StatPill(
                                stat: StatTypes.hp,
                                value: widget.pokemon.hp,
                              ),
                              StatPill(
                                stat: StatTypes.attack,
                                value: widget.pokemon.attack,
                              ),
                              StatPill(
                                stat: StatTypes.defense,
                                value: widget.pokemon.defense,
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
