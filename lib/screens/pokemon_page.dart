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

  // Base host for building shareable links. Update if your host changes.
  static const String _webHost = 'https://pokedex.thoson.io.vn';
  static const String _customScheme = 'pokedex://';

  @override
  void initState() {
    super.initState();
    _loadPokemonDetail();
  }

  Future<void> _loadPokemonDetail() async {
    try {
      final pokemon = await _pokemonService.fetchPokemonDetail(widget.id);
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

    final id = _pokemon!.id;
    final httpsUrl = '$_webHost/pokemon/$id';
    final customUrl = '$_customScheme/pokemon/$id';

    final text = 'Pokédex: ${_pokemon!.name}\n\n${_pokemon!.name.toUpperCase()}\n\nSee details:\n$httpsUrl\n'
        'Open in app: $customUrl';

    // share_plus's Share API may not support a `subject` named parameter
    // on all platforms/versions. Use the SharePlus.instance.share API which
    // is the non-deprecated API surface.
    // Prefer using SharePlus.instance.share; it supports `subject` on
    // platforms where available. If `subject` causes an analyzer error in
    // your environment, remove the `subject:` named parameter.
    try {
      SharePlus.instance.share(ShareParams(text: text, title: 'Pokédex: ${_pokemon!.name}'));
    } catch (_) {
      // Fallback to the simple share call if the instance API doesn't accept subject.
      SharePlus.instance.share(ShareParams(text: text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(_pokemon?.name.toUpperCase() ?? 'Loading...'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePokemon,
            tooltip: 'Share',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pokemon == null
          ? const Center(child: Text('Failed to load Pokemon'))
          : Center(
              child: SingleChildScrollView(
                // For smaller screens
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'pokemon_${_pokemon!.id}',
                      child: CachedNetworkImage(
                        imageUrl: _pokemon!.imageUrl,
                        width: 300,
                        height: 300,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 50),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '#${_pokemon!.id.toString().padLeft(3, '0')}',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _pokemon!.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
