import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MovieDetails extends StatelessWidget {
  final Map<String, dynamic> movieData;

  const MovieDetails({super.key, required this.movieData});

  @override
  Widget build(BuildContext context) {
    final show = movieData['show'];
    final image = show['image'];
    final summary = show['summary'] ?? '';
    final language = show['language'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          show['name'] ?? 'Unknown',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null && image['medium'] != null)
              Center(
                child: Image.network(image['medium']),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                show['name'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  const Text(
                    'Language: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    language,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Html(
              data: summary,
              style: {
                'body': Style(
                  fontSize: FontSize(16.0),
                  color: Colors.white,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
