import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  final String userId;

  WishlistPage({required this.userId});

  final CollectionReference _wishlist = FirebaseFirestore.instance.collection('wishlists').doc('user_id').collection('items'); // Replace 'user_id' with the actual user ID.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: _wishlist.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (streamSnapshot.hasError) {
            return Center(
              child: Text('Error: ${streamSnapshot.error}'),
            );
          }
          if (!streamSnapshot.hasData) {
            return const Center(
              child: Text('No data found'),
            );
          }

          final List<DocumentSnapshot> items = streamSnapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = items[index];
              return Card(
                color: const Color.fromARGB(255, 88, 136, 190),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Badge(
                    backgroundColor: const Color.fromARGB(255, 74, 4, 106),
                    child: Text(
                      documentSnapshot['Location'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  title: Text(
                    documentSnapshot['Type'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(documentSnapshot['Price'].toString()),
                  trailing: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Renting ${documentSnapshot['Type']}')),
                      );
                    },
                    child: const Text('Rent'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
