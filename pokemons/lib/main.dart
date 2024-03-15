import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemons/screens/pokemon_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyBOu-UYC6OypPOeL2FMi57lIP6g3fQih5E',
            appId: '1:1005980474313:web:1f00176d022ba3312fa618',
            messagingSenderId: '1005980474313',
            projectId: 'pokemon-e927b'));
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyApyWN_4Mio0j39bxK58y1xmsUMQNkFmtA',
          appId: '1:1005980474313:android:e6d02f251e52ba9f2fa618',
          messagingSenderId: '1005980474313',
          projectId: 'pokemon-e927b'),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const PokemonListScreen(),
    );
  }
}
