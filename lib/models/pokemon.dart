class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({required this.id, required this.name, required this.imageUrl});

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
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
      );
    }
    // Handling detail response
    else {
      return Pokemon(
        id: json['id'],
        name: json['name'],
        imageUrl: json['sprites']['front_default'] ?? '',
      );
    }
  }
}
