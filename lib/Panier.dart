import 'package:flutter/material.dart';
import 'Article.dart';
import 'ArticleDetailPage.dart';


class PanierPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey; // Ajoutez cette ligne
  final List<Article> allArticles;
  final Set<int> panier;
  final Function(int) togglePanier;

  const PanierPage({
    Key? key,
    required this.scaffoldKey, // Ajoutez cette ligne
    required this.allArticles,
    required this.panier,
    required this.togglePanier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Article> panierArticles =
    allArticles.where((article) => panier.contains(article.id)).toList();
    double total = panierArticles.fold(0, (prev, curr) => prev + curr.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(), // Utilisez scaffoldKey ici
        ),
      ),
      body: ListView.builder(
        itemCount: panierArticles.length + 1,
        itemBuilder: (context, index) {
          if (index == panierArticles.length) {
            return ListTile(
              title: Text('Total: ${total}€'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Faire quelque chose pour valider la commande
                },
                child: const Text('Valider la commande'),
              ),
            );
          } else {
            final article = panierArticles[index];
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
                icon: panier.contains(article.id)
                    ? Icon(Icons.shopping_cart, color: Colors.blue)
                    : Icon(Icons.shopping_cart_outlined),
                onPressed: () => togglePanier(article.id),
              ),
            );
          }
        },
      ),
    );
  }
}
