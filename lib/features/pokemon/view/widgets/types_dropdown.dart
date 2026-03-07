import 'package:flutter/material.dart';
import 'package:pokenav/features/pokemon/data/constants.dart';
import 'package:pokenav/features/pokemon/view_model/pokemon_list_view_model.dart';

class PokemonTypesDropdown extends StatelessWidget {
  final PokemonListViewModel viewModel;

  const PokemonTypesDropdown({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return DropdownButton<PokemonType>(
          value: viewModel.activeFilter,
          items: [
            DropdownMenuItem<PokemonType>(
              value: null,
              child: Image.asset('assets/types/all.png', height: 32),
            ),
            ...PokemonType.values
                .where((type) => type != PokemonType.unknown)
                .map(
                  (type) => DropdownMenuItem<PokemonType>(
                    value: type,
                    child: Image.asset(
                      'assets/types/${type.name}.png',
                      height: 32,
                    ),
                  ),
                ),
          ],
          onChanged: (value) => viewModel.applyFilter(value),
          isDense: true,
          underline: SizedBox.shrink(),
          iconSize: 0.0,
        );
      },
    );
  }
}
