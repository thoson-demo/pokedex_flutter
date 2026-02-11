import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _isFooterHovered = false;
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
    final primary = theme.primaryColor;
    final secondary = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondary.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: secondary.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header & Search
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    children: [
                      Text(
                        'POKEDEX',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: primary,
                          fontSize: 48,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(color: primary, blurRadius: 20),
                            const Shadow(color: Colors.white, blurRadius: 2),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Neon Floating Search Bar
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primary.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search Protocol...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: Icon(Icons.search, color: secondary),
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
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Data Found',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                          itemCount: _pokemonList.length + (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _pokemonList.length) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: secondary,
                                ),
                              );
                            }
                            return PokemonCard(pokemon: _pokemonList[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MouseRegion(
                        onEnter: (_) => setState(() => _isFooterHovered = true),
                        onExit: (_) => setState(() => _isFooterHovered = false),
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'thoson.it@gmail.com',
                            );
                            try {
                              if (await canLaunchUrl(emailLaunchUri)) {
                                await launchUrl(emailLaunchUri);
                              }
                            } catch (e) {
                              // Handle error
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              bottom: 2,
                            ), // Underline offset
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _isFooterHovered
                                      ? Colors.grey[600]!
                                      : Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Text(
                              '© THOSON - thoson.it@gmail.com',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
