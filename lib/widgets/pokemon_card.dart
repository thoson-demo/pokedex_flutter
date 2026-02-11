import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTap: () => context.go('/pokemon/${widget.pokemon.id}'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? theme.colorScheme.secondary
                    : primary.withOpacity(0.3),
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? theme.colorScheme.secondary.withOpacity(0.4)
                      : primary.withOpacity(0.1),
                  blurRadius: _isHovered ? 20 : 10,
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Cyberpunk Grid Background
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: CustomPaint(painter: GridPainter(color: primary)),
                  ),
                ),
                // Glow behind image
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.4),
                          blurRadius: 50,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Area
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Hero(
                          tag: 'pokemon_${widget.pokemon.id}',
                          child: CachedNetworkImage(
                            imageUrl: widget.pokemon.imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(color: primary),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    // Content Area (Glassmorphism overlay)
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          border: Border(
                            top: BorderSide(color: primary.withOpacity(0.2)),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '#${widget.pokemon.id.toString().padLeft(3, '0')}',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.secondary,
                                shadows: [
                                  Shadow(
                                    color: theme.colorScheme.secondary,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.pokemon.name.toUpperCase(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                                letterSpacing: 1.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const double spacing = 20;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
