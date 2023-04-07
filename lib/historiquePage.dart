import 'package:flutter/material.dart';
import 'Article.dart';
import 'ArticleDetailPage.dart';

class HistoriqueAchatsPage extends StatefulWidget {
  final List<Article> historiqueAchats;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HistoriqueAchatsPage({Key? key, required this.historiqueAchats, required this.scaffoldKey}) : super(key: key);

  @override
  _HistoriqueAchatsPageState createState() => _HistoriqueAchatsPageState();
}

class _HistoriqueAchatsPageState extends State<HistoriqueAchatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des achats'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.historiqueAchats.length,
        itemBuilder: (context, index) {
          final article = widget.historiqueAchats[index];
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
