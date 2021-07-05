import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/post_repository.dart';

import 'bloc/post_bloc.dart';
import 'post.dart';

void main() {
  runApp(BlocProvider(
    create: (_) => PostBloc(PostRepository()),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<PostBloc>().add(PostFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News App')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoadSuccess) {
            if (state.posts.isNotEmpty) {
              return ListView.separated(
                padding: const EdgeInsets.all(10),
                separatorBuilder: (_, index) => Divider(),
                itemCount: state.posts.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(state.posts[index].title),
                    subtitle: Text(state.posts[index].name),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(state.posts[index]),
                        )),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No News'),
              );
            }
          }

          if (state is PostLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          }

          return Container();
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Post post;

  const DetailPage(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Detail')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (post.urlToImage.isNotEmpty)
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(post.urlToImage),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(post.publishedAt),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    post.description,
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
