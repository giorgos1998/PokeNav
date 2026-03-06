import 'package:flutter/material.dart';
import 'package:pokenav/features/pokemon/model/pokemon.dart';
import 'package:pokenav/features/pokemon/view/widgets/pokemon_card.dart';
import 'package:pokenav/features/pokemon/view/widgets/types_dropdown.dart';
import 'package:pokenav/features/pokemon/view_model/pokemon_list_view_model.dart';

const pokemons = [
  'bulbasaur',
  'ivysaur',
  'venusaur',
  'charmander',
  'charmeleon',
  'charizard',
  'squirtle',
  'wartortle',
  'blastoise',
  'caterpie',
];

class PokemonListLayout extends StatefulWidget {
  const PokemonListLayout({super.key});

  @override
  State<PokemonListLayout> createState() => _PokemonListLayoutState();
}

class _PokemonListLayoutState extends State<PokemonListLayout> {
  bool _isSearchOpen = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final PokemonListViewModel _viewModel = PokemonListViewModel();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 &&
        !_viewModel.isLoadingNames &&
        !_viewModel.noMoreResults) {
      _viewModel.nextPage();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'backgrounds/pokeball_background.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.transparent,
            title: _isSearchOpen
                ? SizedBox(
                    height: 45,
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Search pokemon...',
                        filled: true,
                        fillColor: Colors.grey.withAlpha(60),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              _viewModel.searchPokemon(_searchController.text),
                        ),
                      ),
                    ),
                  )
                : Text('PokeNav', style: textTheme.headlineLarge),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('icons/pokeball.png'),
            ),
            actions: [
              // if (_viewModel.searchEnabled)
              IconButton(
                icon: Icon(_isSearchOpen ? Icons.close : Icons.search),
                onPressed: () {
                  print('Pressed search');
                  setState(() {
                    _isSearchOpen = !_isSearchOpen;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: PokemonTypesDropdown(viewModel: _viewModel),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, child) {
                    // if (_viewModel.isLoadingNames) {
                    //   return Center(child: CircularProgressIndicator());
                    // } else {
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverList.list(
                          children: [
                            for (var pokemon in _viewModel.pokemons)
                              Center(child: PokemonCard(pokemon)),
                            if (_viewModel.isLoadingNames)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                    // }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
