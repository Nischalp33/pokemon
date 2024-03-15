import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Lists'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search with Pokemon name',
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('pokemon').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey.shade700,
                            highlightColor: Colors.grey.shade100,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    radius: 30,
                                  ),
                                  title: Container(
                                    height: 10,
                                    width: 89,
                                    color: Colors.white60,
                                  ),
                                  subtitle: Container(
                                    height: 10,
                                    width: 89,
                                    color: Colors.white60,
                                  ),
                                  trailing: Container(
                                    height: 10,
                                    width: 89,
                                    color: Colors.white60,
                                  ),
                                )
                              ],
                            ));
                      });
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (searchController.text.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 38,
                              backgroundImage: NetworkImage(
                                snapshot.data!.docs[index].data()['imageUrl'],
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]
                                  .data()['name']
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Type : ${snapshot.data!.docs[index].data()['types'].toString().toUpperCase()}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      } else if (snapshot.data!.docs[index]
                          .data()['name']
                          .toString()
                          .toLowerCase()
                          .contains(searchController.text)) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 38,
                              backgroundImage: NetworkImage(
                                snapshot.data!.docs[index].data()['imageUrl'],
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]
                                  .data()['name']
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Type : ${snapshot.data!.docs[index].data()['types'].toString().toUpperCase()}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
