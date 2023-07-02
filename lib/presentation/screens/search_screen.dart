// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:chat_app/infrastructure/providers/search_provider.dart';
import 'package:chat_app/presentation/components/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchController = TextEditingController();

  final searchProviderr = StateNotifierProvider<Searchprovider, List<dynamic>>(
      (ref) => Searchprovider());
  @override
  Widget build(BuildContext context) {
    final foundUsers = ref.watch(searchProviderr);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onEditingComplete: () async {
                await ref
                    .watch(searchProviderr.notifier)
                    .searchUserId(searchController.text);
              },
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
                print(foundUsers[index]);

                return UserTile(userId: foundUsers[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
