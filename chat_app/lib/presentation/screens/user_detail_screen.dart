import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final String userImageUrl;
  final String name;
  final String email;
  final String secondName;
  const UserDetailScreen({
    super.key,
    required this.name,
    required this.email,
    required this.userImageUrl,
    required this.secondName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              backgroundImage: NetworkImage(userImageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${name} ${secondName}',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: Text(
                          'Add Friend +',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
