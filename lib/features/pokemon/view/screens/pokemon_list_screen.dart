import 'package:flutter/material.dart';
import 'package:pokenav/features/pokemon/view/widgets/pokemon_card.dart';
import 'package:pokenav/features/pokemon/view/widgets/search_box.dart';
import 'package:pokenav/features/pokemon/view/widgets/types_dropdown.dart';
import 'package:pokenav/features/pokemon/view_model/pokemon_list_view_model.dart';

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

    // Load next page when the scrolled list is almost at the end.
    if (currentScroll >= maxScroll - 200 &&
        !_viewModel.isLoadingNames &&
        !_viewModel.isLoadingDetails &&
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
        // App background.
        Positioned.fill(
          child: Image.asset(
            'assets/backgrounds/pokeball_background.png',
            fit: BoxFit.cover,
          ),
        ),

        // App interface.
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.transparent,
            title: _isSearchOpen
                ? SearchBox(
                    textController: _searchController,
                    onSearchPressed: _viewModel.searchPokemon,
                  )
                : Text('PokeNav', style: textTheme.headlineLarge),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/icons/pokeball.png'),
            ),
            actions: [
              ListenableBuilder(
                listenable: _viewModel,
                builder: (context, child) {
                  return _viewModel.activeFilter != null
                      ? IconButton(
                          icon: Icon(
                            _isSearchOpen ? Icons.close : Icons.search,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSearchOpen = !_isSearchOpen;
                              _searchController.text =
                                  _viewModel.searchTerm ?? '';
                            });
                          },
                        )
                      : SizedBox.shrink();
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
