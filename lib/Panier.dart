import 'package:flutter/material.dart';
import 'Article.dart';
import 'ArticleDetailPage.dart';


class PanierPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Article> allArticles;
  final Set<int> panier;
  final Function(int) togglePanier;
  final List<Article> historiqueAchats;
  final Function(List<Article>) onUpdateHistoriqueAchats;



  const PanierPage({
    Key? key,
    required this.allArticles,
    required this.panier,
    required this.togglePanier,
    required this.scaffoldKey,
    required this.historiqueAchats,
    required this.onUpdateHistoriqueAchats,
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
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Commande validée"),
                        content: const Text("Votre commande a été validée avec succès."),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              historiqueAchats.addAll(panierArticles);
                              panier.clear();
                              togglePanier(-1);
                              onUpdateHistoriqueAchats(historiqueAchats);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
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
                onPressed: () {
                  togglePanier(article.id);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
