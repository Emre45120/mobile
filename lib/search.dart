import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Article.dart';
import 'ArticleDetailPage.dart';

class SearchPage extends StatefulWidget {
  final List<Article> allArticles;
  final Set<int> favorites;
  final Function(int) toggleFavorite;
  final Set<int> panier;
  final Function(int) togglePanier;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SearchPage({
    Key? key,
    required this.allArticles,
    required this.favorites,
    required this.toggleFavorite,
    required this.panier,
    required this.togglePanier,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Article> _searchResults = [];
  String _searchText = '';

  void _updateSearchResults(String searchText) {
    setState(() {
      _searchText = searchText;
      _searchResults = widget.allArticles
          .where((article) => article.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _updateSearchResults,
          decoration: InputDecoration(
            hintText: 'Rechercher...',
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final article = _searchResults[index];
          return ListTile(
            leading: Image.network(
              article.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(article.title),
            subtitle: Text('${article.price}€',style: const TextStyle(color: Colors.green)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArticleDetailPage(article: article)),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: widget.favorites.contains(article.id) ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_border), onPressed: () => widget.toggleFavorite(article.id),),

                IconButton(icon: widget.panier.contains(article.id) ? Icon(Icons.shopping_cart, color: Colors.blue) : Icon(Icons.shopping_cart_outlined), onPressed: () => widget.togglePanier(article.id),),

              ],
            ),
          );
        },
      ),
    );
  }
}
