import 'package:flutter/material.dart';
import 'Article.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Ajoutez cette ligne pour centrer le contenu de la colonne
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                article.image,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Ajoutez cette ligne pour centrer le contenu de cette colonne
                children: [
                  Text(
                    article.title,
                    textAlign: TextAlign.center, // Ajoutez cette ligne pour centrer le texte
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${article.price}€',
                    textAlign: TextAlign.center, // Ajoutez cette ligne pour centrer le texte
                    style: TextStyle(fontSize: 18,color: Colors.green)
                  ),
                  Text(
                    'Catégorie : ${article.category}',
                    textAlign: TextAlign.center, // Ajoutez cette ligne pour centrer le texte
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Description :',
                    textAlign: TextAlign.center, // Ajoutez cette ligne pour centrer le texte
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    article.description,
                    textAlign: TextAlign.center, // Ajoutez cette ligne pour centrer le texte
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}