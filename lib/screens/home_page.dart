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
  bool _isLoading = false;
  int _offset = 0;
  static const int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadMorePokemon();
  }

  Future<void> _loadMorePokemon() async {
    if (_isLoading) return;
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
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokedex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
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
              crossAxisCount = 3; // Tablet/Large Phone
            } else {
              crossAxisCount = 2; // Phone
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _pokemonList.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _pokemonList.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return PokemonCard(pokemon: _pokemonList[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
