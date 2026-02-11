import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PokemonService _pokemonService = PokemonService();
  final List<Pokemon> _pokemonList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  int _offset = 0;
  static const int _limit = 20;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMorePokemon();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePokemon() async {
    if (_isLoading || _searchQuery.isNotEmpty) return;
    setState(() => _isLoading = true);

    try {
      final newPokemon = await _pokemonService.fetchPokemonList(
        offset: _offset,
        limit: _limit,
      );
      setState(() {
        _pokemonList.addAll(newPokemon);
        _offset += _limit;
        _isLoading = false;
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchQuery = '';
        _pokemonList.clear();
        _offset = 0;
      });
      _loadMorePokemon();
      return;
    }

    setState(() {
      _isLoading = true;
      _searchQuery = query;
      _pokemonList.clear();
    });

    try {
      final pokemon = await _pokemonService.fetchPokemonDetail(
        query.toLowerCase(),
      );
      setState(() {
        _pokemonList.add(pokemon);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Pokemon not found');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  Text(
                    'POKEMON WIKI',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: theme.primaryColor,
                      fontSize: 28,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Floating Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Pokemon...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.primaryColor,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onSubmitted: _performSearch,
                    ),
                  ),
                ],
              ),
            ),

            // Grid Section
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!_isLoading &&
                      _searchQuery.isEmpty &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    _loadMorePokemon();
                  }
                  return false;
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount;
                    if (constraints.maxWidth > 1200) {
                      crossAxisCount = 6;
                    } else if (constraints.maxWidth > 900) {
                      crossAxisCount = 5;
                    } else if (constraints.maxWidth > 600) {
                      crossAxisCount = 3;
                    } else {
                      crossAxisCount = 2;
                    }

                    if (_pokemonList.isEmpty && !_isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Pokemon found',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.85, // Adjusted for card content
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: _pokemonList.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _pokemonList.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return PokemonCard(pokemon: _pokemonList[index]);
                      },
                    );
                  },
                ),
              ),
            ),

            // Minimal Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '© ThoSon',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' • thoson.it@gmail.com',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
