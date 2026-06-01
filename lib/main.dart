import 'package:flutter/material.dart';
import 'screens/pokemon_detail_screen.dart';

void main() => runApp(PokedexApp());

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kBgDark,
        appBarTheme: const AppBarTheme(backgroundColor: kPokeRed, elevation: 0),
      ),
      home: const PokemonDetailScreen(pokemon: kPikachuData),
    );
  }
}
