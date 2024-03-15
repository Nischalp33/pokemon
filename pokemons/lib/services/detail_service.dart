import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemons/services/Utilities/app_url.dart';

Future<void> fetchPokemonData() async {
  try {
    // Make a request to the Pokemon API
    final pokemonResponse = await http.get(Uri.parse(AppUrl.pokemonAPIUrl));

    if (pokemonResponse.statusCode == 200) {
      // Parse the JSON response
      final pokemonData = json.decode(pokemonResponse.body);

      // Extract the URLs of secondary APIs from the Pokémon API response
      final List<dynamic> urls = pokemonData['results'] ?? [];

      final firestore = FirebaseFirestore.instance;

      // Iterate through the URLs
      for (final urlObject in urls) {
        final url = urlObject['url'];
        if (url != null) {
          final secondaryResponse = await http.get(Uri.parse(url));

          if (secondaryResponse.statusCode == 200) {
            final secondaryData = json.decode(secondaryResponse.body);

            // Store the secondary API data in Firestore
            await firestore.collection('pokemon').add(
              {
                'name': secondaryData["name"],
                'imageUrl': secondaryData["sprites"]['front_default'],
                'types': secondaryData["types"][0]["type"]["name"]
              },
            );
            print('Data added to Firestore: $secondaryData');
          } else {
            print(
                'Failed to fetch data from secondary API. Status code: ${secondaryResponse.statusCode}');
          }
        }
      }
    } else {
      print(
          'Failed to fetch data from Pokemon API. Status code: ${pokemonResponse.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
