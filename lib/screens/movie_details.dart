import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MovieDetails extends StatelessWidget {
  final Map<String, dynamic> movieData;

  const MovieDetails({super.key, required this.movieData});

  @override
  Widget build(BuildContext context) {
    // Extract movie details from movieData and display them here
    final show = movieData['show'];
    final image = show['image'];
    final summary = show['summary'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(show['name'] ?? 'Unknown'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null && image['medium'] != null)
              Image.network(image['medium']),
            const SizedBox(height: 10),
            Text(
              show['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Html(
              data: summary,
              style: {
                'body': Style(
                  fontSize: FontSize(16.0),
                ),
              },
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
