import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonPage extends StatefulWidget {
  final int id;

  const PokemonPage({super.key, required this.id});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final PokemonService _pokemonService = PokemonService();
  Pokemon? _pokemon;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPokemonDetail();
  }

  Future<void> _loadPokemonDetail() async {
    try {
      final pokemon = await _pokemonService.fetchPokemonDetail(
        widget.id.toString(),
      );
      if (mounted) {
        setState(() {
          _pokemon = pokemon;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _sharePokemon() {
    if (_pokemon == null) return;
    final text = 'Check out ${_pokemon!.name} on Neon Pokedex!';
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_pokemon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Failed to load Pokemon')),
      );
    }

    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final secondary = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Cyberpunk Background Elements
          Positioned(
            top: -200,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [primary.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                floating: false,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/'),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.share, color: secondary),
                    onPressed: _sharePokemon,
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      // HUD Circle
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primary.withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.1),
                              blurRadius: 50,
                            ),
                          ],
                        ),
                      ),
                      Hero(
                        tag: 'pokemon_${_pokemon!.id}',
                        child: CachedNetworkImage(
                          imageUrl: _pokemon!.imageUrl,
                          height: 280,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(color: secondary),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              _pokemon!.name.toUpperCase(),
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: secondary, blurRadius: 20),
                                  const Shadow(
                                    color: Colors.white,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Text(
                                '#${_pokemon!.id.toString().padLeft(3, '0')}',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Info Grid (Glassmorphism)
                      Row(
                        children: [
                          Expanded(
                            child: _buildNeonCard(
                              context,
                              'HEIGHT',
                              '${_pokemon!.height ?? 0 / 10} M',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildNeonCard(
                              context,
                              'WEIGHT',
                              '${_pokemon!.weight ?? 0 / 10} KG',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Types with Glow
                      Text('TYPE PROTOCOL', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _pokemon!.types
                            .map(
                              (type) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: _getTypeColor(type),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getTypeColor(
                                        type,
                                      ).withOpacity(0.4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  type.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        color: _getTypeColor(type),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 32),

                      // Abilities
                      Text('ABILITIES', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _pokemon!.abilities
                            .map(
                              (ability) => Chip(
                                label: Text(
                                  ability.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: theme.cardTheme.color,
                                shape: StadiumBorder(
                                  side: BorderSide(color: Colors.white12),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 32),

                      // Stats (Neon Bars)
                      Text('SYSTEM STATS', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      ..._pokemon!.stats.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    entry.value.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: entry.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [primary, secondary],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: secondary.withOpacity(0.5),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 255 - entry.value,
                                      child: const SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNeonCard(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: primary, blurRadius: 10)],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.cyanAccent;
      case 'grass':
        return Colors.greenAccent;
      case 'electric':
        return Colors.yellowAccent;
      case 'psychic':
        return Colors.purpleAccent;
      case 'poison':
        return Colors.deepPurpleAccent;
      default:
        return Colors.white60;
    }
  }
}
