import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PropertyList extends StatefulWidget {
  const PropertyList({super.key});

  @override
  State<PropertyList> createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final CollectionReference _items = FirebaseFirestore.instance.collection('items');

  String searchText = '';

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Create your item",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                      labelText: 'Type', hintText: 'eg.Apt'),
                ),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                      labelText: 'Location', hintText: 'eg.Skudai'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: const InputDecoration(
                      labelText: 'Price', hintText: 'eg.1200'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        final String type = _typeController.text;
                        final String location = _locationController.text;
                        final int? price = int.tryParse(_priceController.text);
                        if (price != null) {
                          await _items.add({
                            "Type": type,
                            "Location": location,
                            "Price": price
                          });
                          _typeController.text = '';
                          _locationController.text = '';
                          _priceController.text = '';

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Create")),
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _typeController.text = documentSnapshot['Type'];
      _locationController.text = documentSnapshot['Location'];
      _priceController.text = documentSnapshot['Price'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Update your item",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                      labelText: 'Type', hintText: 'eg.Apt'),
                ),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                      labelText: 'Location', hintText: 'eg.Skudai'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: const InputDecoration(
                      labelText: 'Price', hintText: 'eg.1200'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String type = _typeController.text;
                      final String location = _locationController.text;
                      final int? price = int.tryParse(_priceController.text);
                      if (price != null) {
                        await _items
                            .doc(documentSnapshot!.id)
                            .update({"Type": type, "Location": location, "Price": price});
                        _typeController.text = '';
                        _locationController.text = '';
                        _priceController.text = '';

                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productID) async {
    await _items.doc(productID).delete();

    // for snackBar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have successfully deleted an item")));
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  bool isSearchClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: isSearchClicked
            ? Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 85, 7, 106),
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
                hintText: 'Search.. '),
          ),
        )
            : const Text('Property List'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchClicked = !isSearchClicked;
                });
              },
              icon: Icon(isSearchClicked ? Icons.close : Icons.search))
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

          final List<DocumentSnapshot> items = streamSnapshot.data!.docs
              .where((doc) => doc['Type'].toLowerCase().contains(
            searchText.toLowerCase(),
          ))
              .toList();

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
                            fontWeight: FontWeight.bold, color: Colors.black
                        )
                    ),
                    subtitle: Text(documentSnapshot['Price'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => _update(documentSnapshot),
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () => _delete(documentSnapshot.id),
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
