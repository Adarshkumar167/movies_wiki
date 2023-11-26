import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:movies_list/screens/movie_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _searchResults = [];

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
        _searchResults = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GestureDetector(
          onTap: () {},
          child: const Text(
            'Search',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final show = _searchResults[index]['show'];
          final image = show['image'];
          final summary = show['summary'] ?? '';
          final truncatedSummary =
              summary.split(' ').take(30).join(' ') + '...';

          return InkWell(
            onTap: () {
              _navigateToMovieDetails(_searchResults[index]);
            },
            child: Padding(
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
                        width: 128,
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
            ),
          );
        },
      ),
    );
  }

  void _navigateToMovieDetails(Map<String, dynamic> movieData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetails(movieData: movieData),
      ),
    );
  }
}
