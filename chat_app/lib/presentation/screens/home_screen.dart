import 'package:chat_app/presentation/screens/chat_screen.dart';
import 'package:chat_app/presentation/screens/friend_requests_screen.dart';
import 'package:chat_app/presentation/screens/profile_screen.dart';
import 'package:chat_app/presentation/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _screens = [
    const ChatScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  int _selectedIndex = 2;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Chat App'),
        backgroundColor: Colors.black,
        actions: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshots.data!['friendRequests'].length != 0) {
                    return Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FriendRequestsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4.5),
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Text(
                              snapshots.data!['friendRequests'].length
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FriendRequestsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications),
                    );
                  }
                }
              }),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: GNav(
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.all(13),
            onTabChange: (index) => navigateBottomBar(index),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.people,
                text: 'Friends',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.home,
                text: 'Home',
              )
            ],
          ),
        ),
      ),
    );
  }
}
