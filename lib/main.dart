import 'package:SAE/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Article.dart';
import 'ArticleDetailPage.dart';
import 'LoginPage.dart';
import 'dart:math';
import 'Favoris.dart';
import 'Panier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'AuthWrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'historiquePage.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(
        child: AppWithNavigation(),
      ),
    );
  }
}

class AppWithNavigation extends StatefulWidget {
  const AppWithNavigation({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

List<Article> _allArticles = [];

class _MyAppState extends State<AppWithNavigation> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<int> _favorites = {};
  Set<int> _panier = {};
  List<Article> historiqueAchats = [];
  StreamSubscription<User?>? _authStateSubscription; // Ajoutez cette ligne

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _updateHistoriqueAchats(List<Article> articlesAchetes) {
    setState(() {
      historiqueAchats.addAll(articlesAchetes);
    });
  }

  void initAuthStateListener() {
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        // Si l'utilisateur est connecté, chargez les données
        loadFavorites().then((loadedFavorites) {
          setState(() {
            _favorites = loadedFavorites;
          });
        });

        loadPanier().then((loadedPanier) {
          setState(() {
            _panier = loadedPanier;
          });
        });
      } else {
        // Si l'utilisateur est déconnecté, videz les données
        setState(() {
          _favorites = {};
          _panier = {};
        });
      }
    });
  }

  List<Widget> _buildPages() {
    return [
      MyHomePage(
        scaffoldKey: _scaffoldKey,
        title: 'Accueil',
        favorites: _favorites,
        toggleFavorite: _toggleFavorite,
        panier: _panier,
        togglePanier: _togglePanier,
      ),
      FavoritesPage(
        scaffoldKey: _scaffoldKey,
        allArticles: _allArticles,
        favorites: _favorites,
        toggleFavorite: _toggleFavorite,
      ),
      PanierPage(
        scaffoldKey: _scaffoldKey,
        allArticles: _allArticles,
        panier: _panier,
        togglePanier: _togglePanier,
        historiqueAchats: [],
        onUpdateHistoriqueAchats: _updateHistoriqueAchats,
      ),
      LoginPage(
          scaffoldKey: _scaffoldKey
      ),
      SearchPage(
          allArticles: _allArticles,
          favorites: _favorites,
          toggleFavorite: _toggleFavorite,
          panier: _panier,
          togglePanier: _togglePanier, scaffoldKey: _scaffoldKey,
      ),
      HistoriqueAchatsPage(
          historiqueAchats: historiqueAchats, scaffoldKey: _scaffoldKey,
      ),
    ];
  }


  Future<void> saveFavorites(Set<int> favorites) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favorites.map((id) => id.toString()).toList());
  }

  Future<void> savePanier(Set<int> panier) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('panier', panier.map((id) => id.toString()).toList());
  }

  Future<Set<int>> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedFavorites = prefs.getStringList('favorites');
    return storedFavorites != null ? storedFavorites.map((id) => int.parse(id)).toSet() : {};
  }

  Future<Set<int>> loadPanier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedPanier = prefs.getStringList('panier');
    return storedPanier != null ? storedPanier.map((id) => int.parse(id)).toSet() : {};
  }


  @override
  void initState() {
    super.initState();
    initAuthStateListener();
    loadFavorites().then((loadedFavorites) {
      setState(() {
        _favorites = loadedFavorites;
      });
    });

    loadPanier().then((loadedPanier) {
      setState(() {
        _panier = loadedPanier;
      });
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }


  void _toggleFavorite(int id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
      saveFavorites(_favorites);
    });
  }

  void _togglePanier(int id) {
    setState(() {
      if (_panier.contains(id)) {
        _panier.remove(id);
      } else {
        _panier.add(id);
      }
      savePanier(_panier);
    });
  }


  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
                'Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              _navigateToPage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favoris'),
            onTap: () {
              _navigateToPage(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Panier'),
            onTap: () {
              _navigateToPage(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Rechercher'),
            onTap: () {
              _navigateToPage(4); // 4 est l'index de la page de recherche
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historique des achats'),
            onTap: () {
              _navigateToPage(5); // 5 est l'index de la page d'historique des achats
              Navigator.pop(context);
            },
          ),
          if (user == null)
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Connexion'),
              onTap: () {
                _navigateToPage(3);
                Navigator.pop(context);
              },
            ),
          if (user != null)
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Déconnexion'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(
        index: _currentIndex,
        children: _buildPages(),
      ),
      drawer: _buildDrawer(context),
    );
  }

}


class MyHomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Set<int> favorites;
  final Function(int) toggleFavorite;
  final Set<int> panier;
  final Function(int) togglePanier;
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
    required this.favorites,
    required this.toggleFavorite,
    required this.panier,
    required this.togglePanier,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _perPage = 6;
  int _page = 1;

  List<Article> _displayedArticles = [];
  Set<int> _favorites = {};
  Set<int> _panier = {};


  void _toggleFavorite(int id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  void _togglePanier(int id) {
    setState(() {
      if (_panier.contains(id)) {
        _panier.remove(id);
      } else {
        _panier.add(id);
      }
    });
  }

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      _allArticles = jsonResponse.map((article) => Article.fromJson(article)).toList();
      _updateDisplayedArticles();
      return _displayedArticles;
    } else {
      throw Exception('Erreur lors du chargement des articles');
    }
  }

  void _updateDisplayedArticles() {
    int startIndex = (_page - 1) * _perPage;
    int endIndex = min(startIndex + _perPage, _allArticles.length);
    _displayedArticles = _allArticles.sublist(startIndex, endIndex);
  }

  void _nextPage() {
    if ((_page * _perPage) < _allArticles.length) {
      setState(() {
        _page += 1;
        _updateDisplayedArticles();
      });
    }
  }

  void _previousPage() {
    if (_page > 1) {
      setState(() {
        _page -= 1;
        _updateDisplayedArticles();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
          )
      ),
      body: FutureBuilder<List<Article>>(
        future: fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur lors du chargement des articles'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _displayedArticles.length,
                    itemBuilder: (context, index) {
                      final article = _displayedArticles[index];
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
                ),
                Row(
                  children: [
                    if (_page > 1)
                      ElevatedButton(
                        onPressed: _previousPage,
                        child: const Icon(Icons.arrow_back),
                      ),
                    const Spacer(),
                    if ((_page * _perPage) < _allArticles.length)
                      ElevatedButton(
                        onPressed: _nextPage,
                        child: const Icon(Icons.arrow_forward),
                      ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}