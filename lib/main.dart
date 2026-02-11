import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:url_strategy/url_strategy.dart';
import 'screens/home_page.dart';
import 'screens/pokemon_page.dart';
import 'theme/app_theme.dart';

void main() {
  // Remove the '#' from web URLs (use path URL strategy)
  setPathUrlStrategy();
  runApp(const PokedexApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'pokemon/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return PokemonPage(id: id);
          },
        ),
      ],
    ),
  ],
);

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
