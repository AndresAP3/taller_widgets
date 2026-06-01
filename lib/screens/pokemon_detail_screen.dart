import 'package:flutter/material.dart';

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

class PokemonDetailScreen extends StatelessWidget {
  final PokemonData pokemon;
  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('fase 1 ok')));
  }
}
