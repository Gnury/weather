import 'dart:math';

import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  List<String> items = List.generate(50, (index) => Random().nextInt(10).toString());
  List<String> filteredItems = [];
  String _query = '';

  void search(String query) {
    setState(
      () {
        _query = query;

        filteredItems = items
            .where(
              (item) => item.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          onChanged: (value) {
            search(value);
          },
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Color.fromARGB(255, 107, 107, 107)),
            fillColor: Color.fromARGB(255, 107, 107, 107),
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 107, 107, 107),
            ),
          ),
        ),
      ),
      body: filteredItems.isNotEmpty || _query.isNotEmpty
          ? filteredItems.isEmpty
              ? const Center(
                  child: Text(
                    'No Results Found',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredItems[index]),
                    );
                  },
                )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
    );
  }
}