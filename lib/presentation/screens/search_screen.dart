// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:chat_app/presentation/components/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  List searchResult = [];
  List foundUsers = [];

  @override
  Widget build(BuildContext context) {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    Future<void> searchUser(String searchTerm) async {
      searchResult = [];
      final querySnapshot =
          await usersCollection.where('name', isEqualTo: searchTerm).get();

      querySnapshot.docs.forEach(
        (document) {
          searchResult.add(document.id);
        },
      );

      setState(() {
        foundUsers = searchResult;
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onEditingComplete: () async =>
                  await searchUser(searchController.text),
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: foundUsers.length,
              itemBuilder: (context, index) {
                return UserTile(
                  userId: foundUsers[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
