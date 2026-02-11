class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final int? height;
  final int? weight;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.height,
    this.weight,
    this.types = const [],
    this.abilities = const [],
    this.stats = const {},
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Handling list response (name, url) which we derive id and image from
    if (json.containsKey('url')) {
      final String url = json['url'];
      // url format: https://pokeapi.co/api/v2/pokemon/1/
      final id = int.parse(url.split('/')[6]);
      return Pokemon(
        id: id,
        name: json['name'],
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      );
    }
    // Handling detail response
    else {
      final List<dynamic> typesList = json['types'] ?? [];
      final List<String> types = typesList
          .map((t) => t['type']['name'].toString())
          .toList();

      final List<dynamic> abilitiesList = json['abilities'] ?? [];
      final List<String> abilities = abilitiesList
          .map((a) => a['ability']['name'].toString())
          .toList();

      final List<dynamic> statsList = json['stats'] ?? [];
      final Map<String, int> stats = {
        for (var s in statsList) s['stat']['name']: s['base_stat'],
      };

      return Pokemon(
        id: json['id'],
        name: json['name'],
        imageUrl:
            json['sprites']['other']['official-artwork']['front_default'] ??
            json['sprites']['front_default'] ??
            '',
        height: json['height'],
        weight: json['weight'],
        types: types,
        abilities: abilities,
        stats: stats,
      );
    }
  }
}
