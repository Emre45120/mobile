import 'package:flutter/material.dart';
import 'Article.dart';
import 'ArticleDetailPage.dart';

class PurchaseHistoryPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Article> allArticles;
  final Set<int> purchaseHistory;

  const PurchaseHistoryPage({
    Key? key,
    required this.scaffoldKey,
    required this.allArticles,
    required this.purchaseHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Article> purchasedArticles =
    allArticles.where((article) => purchaseHistory.contains(article.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des achats'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: ListView.builder(
        itemCount: purchasedArticles.length,
        itemBuilder: (context, index) {
          final article = purchasedArticles[index];
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
          );
        },
      ),
    );
  }
}
