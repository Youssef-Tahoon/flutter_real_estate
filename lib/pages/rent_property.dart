import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'payment_screen.dart';

import 'wishlist_page.dart';

class RentPropertyPage extends StatefulWidget {
  @override
  _RentPropertyPageState createState() => _RentPropertyPageState();
}

class _RentPropertyPageState extends State<RentPropertyPage> {
  final CollectionReference _items = FirebaseFirestore.instance.collection('items');
  final CollectionReference _wishlist = FirebaseFirestore.instance.collection('wishlists').doc('user_id').collection('items'); // Replace 'user_id' with the actual user ID.

  Future<void> _addToWishlist(DocumentSnapshot item) async {
    final wishlistItem = await _wishlist.doc(item.id).get();
    if (wishlistItem.exists) {
      await _wishlist.doc(item.id).delete();
    } else {
      await _wishlist.doc(item.id).set({
        'Type': item['Type'],
        'Location': item['Location'],
        'Price': item['Price']
      });
    }
  }

  Future<bool> _isInWishlist(String itemId) async {
    final wishlistItem = await _wishlist.doc(itemId).get();
    return wishlistItem.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Properties'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishlistPage(userId: 'user_id',)), // Replace 'user_id' with the actual user ID.
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _items.snapshots(),
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
                return FutureBuilder(
                  future: _isInWishlist(documentSnapshot.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final isInWishlist = snapshot.data as bool;
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                isInWishlist ? Icons.favorite : Icons.favorite_border,
                                color: isInWishlist ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                _addToWishlist(documentSnapshot);
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      propertyType: documentSnapshot['Type'],
                                      propertyLocation: documentSnapshot['Location'],
                                      propertyPrice: documentSnapshot['Price'],
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Rent'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
