import 'package:flutter/material.dart';
import 'Article.dart';
import 'ArticleDetailPage.dart';


class FavoritesPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Article> allArticles;
  final Set<int> favorites;
  final Function(int) toggleFavorite;

  const FavoritesPage({
    Key? key,
    required this.scaffoldKey,
    required this.allArticles,
    required this.favorites,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Article> favoriteArticles =
    allArticles.where((article) => favorites.contains(article.id)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(), // Utilisez scaffoldKey ici
        ),
      ),
      body: ListView.builder(
        itemCount: favoriteArticles.length,
        itemBuilder: (context, index) {
          final article = favoriteArticles[index];
          return ListTile(
            leading: Image.network(
              article.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(article.title),
            subtitle: Text('${article.price}€', style: const TextStyle(color: Colors.green)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArticleDetailPage(article: article)),
              );
            },
            trailing: IconButton(
              icon: favorites.contains(article.id)
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border),
              onPressed: () => toggleFavorite(article.id),
            ),
          );
        },
      ),
    );
  }
}


