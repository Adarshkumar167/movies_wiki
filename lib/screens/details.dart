import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response =
        await http.get(Uri.parse("https://api.tvmaze.com/search/shows?q=all"));
    if (response.statusCode == 200) {
      setState(() {
        _movies = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final show = _movies[index]['show'];
          final image = show['image'];
          final summary = show['summary'] ?? '';
          final truncatedSummary =
              summary.split(' ').take(30).join(' ') + '...';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 180,
                      child: image != null && image['medium'] != null
                          ? Image.network(image['medium'])
                          : Image.network(
                              'https://dummyimage.com/210x295/ffffff/000000.jpg&text=Unavailable',
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              show['name'] ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Html(
                            data: truncatedSummary,
                            style: {
                              'body': Style(
                                fontSize: FontSize(14.0),
                                color: Colors.white,
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          }
        },
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search for a movie...',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              searchMovies();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final show = _searchResults[index]['show'];
          final image = show['image'];
          final summary = show['summary'] ?? '';
          final truncatedSummary =
              summary.split(' ').take(30).join(' ') + '...';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 180,
                      child: image != null && image['medium'] != null
                          ? Image.network(image['medium'])
                          : Image.network(
                              'https://dummyimage.com/210x295/ffffff/000000.jpg&text=Unavailable',
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              show['name'] ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Html(
                            data: truncatedSummary,
                            style: {
                              'body': Style(
                                fontSize: FontSize(14.0),
                                color: Colors.white,
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> searchMovies() async {
    final searchTerm = _searchController.text;
    final response = await http
        .get(Uri.parse("https://api.tvmaze.com/search/shows?q=$searchTerm"));

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
