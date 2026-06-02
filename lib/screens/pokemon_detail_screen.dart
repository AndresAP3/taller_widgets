import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const kPokeRed = Color(0xFFCC0000);
const kPokeYellow = Color(0xFFFFCC00);

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

  String get nombreCapitalizado =>
      nombre[0].toUpperCase() + nombre.substring(1);
  String get idFormateado => '#${id.toString().padLeft(3, '0')}';

  factory PokemonData.fromJson(Map<String, dynamic> json) {
    return PokemonData(
      id: json['id'] as int,
      nombre: json['name'] as String,
      urlImagen:
          json['sprites']['other']['official-artwork']['front_default']
              as String,
      tipos: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      altura: (json['height'] as int) / 10,
      peso: (json['weight'] as int) / 10,
      xpBase: json['base_experience'] as int? ?? 0,
      estadisticas: (json['stats'] as List)
          .map(
            (s) => {
              'name': s['stat']['name'] as String,
              'value': s['base_stat'] as int,
            },
          )
          .toList(),
    );
  }
}

Color _colorPorTipo(String tipo) => switch (tipo) {
  'fire' => const Color.fromARGB(255, 223, 75, 30),
  'water' => Colors.blue,
  'electric' => const Color(0xFFD4AF37),
  'grass' => Colors.green,
  'psychic' => const Color.fromARGB(255, 187, 28, 81),
  'normal' => Colors.grey,
  _ => const Color.fromARGB(255, 113, 29, 128),
};

class PokemonDetailScreen extends StatefulWidget {
  final String idONombre;
  const PokemonDetailScreen({super.key, required this.idONombre});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  PokemonData? pokemon;
  String? error;
  bool cargando = true;
  bool _esFavorito = false;
  bool _imagenVisible = false;

  void _toggleFavorito() {
    setState(() {
      _esFavorito = !_esFavorito;
    });
  }

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  Future<void> _buscar() async {
    setState(() {
      cargando = true;
      error = null;
      _imagenVisible = false;
    });
    try {
      final url = Uri.parse(
        'https://pokeapi.co/api/v2/pokemon/${widget.idONombre}',
      );
      final respuesta = await http.get(url);
      if (respuesta.statusCode == 200) {
        final datos = PokemonData.fromJson(jsonDecode(respuesta.body));
        setState(() {
          pokemon = datos;
          cargando = false;
        });
      } else if (respuesta.statusCode == 404) {
        setState(() {
          error = 'Pokemon "${widget.idONombre}" no encontrado';
          cargando = false;
        });
      } else {
        setState(() {
          error = 'Error del servidor: ${respuesta.statusCode}';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error de conexion: $e';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: kPokeRed)),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.catching_pokemon,
                size: 80,
                color: Colors.black26,
              ),
              const SizedBox(height: 16),
              Text(
                error!,
                style: const TextStyle(color: Colors.black45, fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _buscar,
                child: const Text(
                  'Reintentar',
                  style: TextStyle(color: kPokeRed),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final colorTipo = _colorPorTipo(pokemon!.tipos.first);
    final pantallaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pokédex',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _esFavorito ? Icons.favorite : Icons.favorite_border,
              color: _esFavorito ? Colors.redAccent : Colors.white,
            ),
            onPressed: _toggleFavorito,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(height: pantallaHeight * 0.40, color: colorTipo),
          Positioned(
            top: 40,
            right: -50,
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png',
                width: 260,
                height: 260,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemon!.idFormateado,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pokemon!.nombreCapitalizado,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: pokemon!.tipos
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
                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 70,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 15,
                                offset: Offset(0, -5),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _InfoItem(
                                      label: 'Altura',
                                      value: '${pokemon!.altura}m',
                                    ),
                                    _InfoItem(
                                      label: 'Peso',
                                      value: '${pokemon!.peso}kg',
                                    ),
                                    _InfoItem(
                                      label: 'XP base',
                                      value: '${pokemon!.xpBase}',
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Divider(color: Colors.black12),
                                ),
                                const Text(
                                  'Stats',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...pokemon!.estadisticas.map(
                                  (s) => _StatBar(
                                    name: s['name'] as String,
                                    value: s['value'] as int,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: AnimatedOpacity(
                          opacity: _imagenVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeIn,
                          child: Image.network(
                            pokemon!.urlImagen,
                            height: 150,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted && !_imagenVisible) {
                                    setState(() => _imagenVisible = true);
                                  }
                                });
                                return child;
                              }
                              return SizedBox(
                                height: 150,
                                width: 150,
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

  Color _colorForType(String type) {
    switch (type) {
      case 'fire':
        return Colors.deepOrange;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.amber;
      case 'grass':
        return Colors.green;
      case 'psychic':
        return Colors.pink;
      case 'normal':
        return Colors.grey;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: _colorForType(type).withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _colorForType(type).withOpacity(0.6)),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: _colorForType(type),
          fontSize: 11,
          fontWeight: FontWeight.bold,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black45, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _StatBar extends StatelessWidget {
  final String name;
  final int value;
  const _StatBar({required this.name, required this.value});

  Color _barColor() {
    if (value >= 80) return Colors.green;
    if (value >= 50) return Colors.amber.shade700;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 150,
                minHeight: 8,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation(_barColor()),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
