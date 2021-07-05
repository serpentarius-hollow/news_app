import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/post.dart';

class PostRepository {
  Future<List<Post>> getPosts() async {
    try {
      final url = Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=id&apiKey=3eaa07d4cfca434e9239ef018468cd4b');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;

        final List<Post> posts = [];

        List articles = result['articles'];

        articles.forEach((element) {
          posts.add(Post(
            id: element['source']['id'] ?? '',
            name: element['source']['name'] ?? '',
            author: element['author'] ?? '',
            title: element['title'] ?? '',
            description: element['description'] ?? '',
            url: element['url'] ?? '',
            urlToImage: element['urlToImage'] ?? '',
            publishedAt: element['publishedAt'] ?? '',
            content: element['content'] ?? '',
          ));
        });

        return posts;
      } else {
        throw Exception();
      }
    } catch (err) {
      throw Exception();
    }
  }
}
