import 'package:flutter/material.dart';

const kPokeRed = Color(0xFFCC0000);
const kPokeYellow = Color(0xFFFFCC00);
const kBgDark = Color(0xFF1A1A2E);
const kCardBg = Color(0xFF16213E);
const kTextLight = Color(0xFFE0E0E0);
const kTextMuted = Color(0xFF9E9E9E);

class PokemonData {
  final int id;
  final String nombre;
  final String urlImagen;
  final List<String> tipos;
  final double altura;
  final double peso;
  final int xpBase;
  final List<Map<String, dynamic>> estadisticas;

  const PokemonData({
    required this.id,
    required this.nombre,
    required this.urlImagen,
    required this.tipos,
    required this.altura,
    required this.peso,
    required this.xpBase,
    required this.estadisticas,
  });
}

const kPikachuData = PokemonData(
  id: 25,
  nombre: 'pikachu',
  urlImagen:
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/10094.png',
  tipos: ['electric'],
  altura: 0.4,
  peso: 6.0,
  xpBase: 112,
  estadisticas: [
    {'name': 'hp', 'value': 35},
    {'name': 'attack', 'value': 55},
    {'name': 'defense', 'value': 40},
    {'name': 'speed', 'value': 50},
  ],
);

Color _colorPorTipo(String tipo) => switch (tipo) {
  'fire' => const Color(0xFFB84B15),
  'water' => const Color(0xFF1A6B9A),
  'electric' => const Color(0xFF8B6914),
  'grass' => const Color(0xFF2D6E3E),
  'psychic' => const Color(0xFF8B1A5E),
  'ghost' => const Color(0xFF3D2B6E),
  'normal' => const Color(0xFF5A5A5A),
  _ => const Color(0xFF4A3080),
};

class PokemonDetailScreen extends StatelessWidget {
  final PokemonData pokemon;
  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final colorTipo = _colorPorTipo(pokemon.tipos.first);
    final pantalla = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(height: pantalla * 0.45, color: colorTipo),

          Positioned(
            top: 20,
            right: -50,
            child: Opacity(
              opacity: 0.12,
              child: Image.network(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png',
                width: 320,
                height: 320,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                      SizedBox(height: 2),
                      Text(
                        pokemon.nombre[0].toUpperCase() +
                            pokemon.nombre.substring(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: pokemon.tipos
                            .map(
                              (t) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: _TypeChip(type: t),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Base Stats',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                SizedBox(height: 14),
                                ...pokemon.estadisticas.map(
                                  (s) => _StatBar(
                                    name: s['name'] as String,
                                    value: s['value'] as int,
                                  ),
                                ),

                                SizedBox(height: 20),
                                Divider(color: Colors.black12),
                                SizedBox(height: 12),

                                Text(
                                  'Info',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                SizedBox(height: 14),
                                _InfoItem(
                                  label: 'Altura',
                                  value: '${pokemon.altura} m',
                                ),
                                _InfoItem(
                                  label: 'Peso',
                                  value: '${pokemon.peso} kg',
                                ),
                                _InfoItem(
                                  label: 'XP base',
                                  value: '${pokemon.xpBase}',
                                ),
                                SizedBox(height: 20),
                                Divider(color: Colors.black12),
                                SizedBox(height: 12),
                                Text(
                                  'Habilidades',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'electricidad estática, pararrayos, Bola Luminosa (oculta)',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 0,
                        child: Image.network(
                          pokemon.urlImagen,
                          height: 160,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return SizedBox(
                              height: 160,
                              width: 160,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: colorTipo,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.catching_pokemon,
                            size: 80,
                            color: colorTipo,
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

class _TypeChip extends StatelessWidget {
  final String type;
  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white38),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(color: Colors.black45, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String name;
  final int value;
  const _StatBar({required this.name, required this.value});

  Color _barColor() {
    if (value >= 80) return Colors.greenAccent;
    if (value >= 50) return Colors.amber;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              name,
              style: TextStyle(color: Colors.black45, fontSize: 13),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              style: TextStyle(
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 150,
                minHeight: 6,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation(_barColor()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
