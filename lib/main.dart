import 'package:flutter/material.dart';
import 'screens/pokemon_detail_screen.dart';

void main() => runApp(const PokedexApp());

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFCC0000),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const PantallaBusqueda(),
    );
  }
}

class PantallaBusqueda extends StatefulWidget {
  const PantallaBusqueda({super.key});

  @override
  State<PantallaBusqueda> createState() => _PantallaBusquedaState();
}

class _PantallaBusquedaState extends State<PantallaBusqueda> {
  final controlador = TextEditingController();

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  void _buscar() {
    final texto = controlador.text.toLowerCase().trim();
    if (texto.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PokemonDetailScreen(idONombre: texto)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const amarilloPoke = Color(0xFFFFCC00);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.58,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF12131A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.22,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: 0.03,
                child: SizedBox(
                  width: size.width * 0.75,
                  height: size.width * 0.75,
                  child: CustomPaint(painter: PokeballPainter()),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 25,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 85,
                            height: 85,
                            child: CustomPaint(painter: PokeballPainter()),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Pokédex',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2.5,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: amarilloPoke.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: amarilloPoke, width: 1.5),
                        ),
                        child: const Text(
                          'EDICIÓN ULTRA BALL',
                          style: TextStyle(
                            fontSize: 11,
                            color: amarilloPoke,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 35,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Buscar Pokémon',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF12131A),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Ingresa el nombre o número para iniciar el registro.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: controlador,
                              style: const TextStyle(
                                color: Color(0xFF12131A),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Ej: Pikachu o 25...',
                                hintStyle: const TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.normal,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  color: amarilloPoke,
                                  size: 26,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF4F6F9),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onSubmitted: (_) => _buscar(),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF12131A,
                                      ).withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF12131A),
                                    foregroundColor: amarilloPoke,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: _buscar,
                                  child: const Text(
                                    'BUSCAR',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      letterSpacing: 1.8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PokeballPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final paintDark = Paint()..color = const Color(0xFF2C2C35);
    final paintWhite = Paint()..color = Colors.grey.shade50;
    final paintYellow = Paint()..color = const Color(0xFFFFCC00);
    final paintBorder = Paint()
      ..color = const Color(0xFF1A1A1F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawCircle(center, radius, paintDark);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      3.1416,
      true,
      paintWhite,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      3.44,
      0.6,
      true,
      paintYellow,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.9),
      5.38,
      0.6,
      true,
      paintYellow,
    );

    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paintBorder,
    );
    canvas.drawCircle(center, radius, paintBorder);

    canvas.drawCircle(
      center,
      radius * 0.28,
      paintBorder..style = PaintingStyle.fill,
    );
    canvas.drawCircle(center, radius * 0.24, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      radius * 0.12,
      paintBorder..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
