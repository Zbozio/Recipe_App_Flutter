import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'recipe_detail_screen.dart';
import 'favorite_recipes_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List recipes = [];
  List<Map> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    loadFavorites();
  }

  Future<void> fetchRecipes() async {
    const url =
        'https://api.spoonacular.com/recipes/random?number=30&apiKey=8c7c315aaf5d4dfcb74b8d7a39569362';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        recipes = json.decode(response.body)['recipes'];
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedFavorites = prefs.getString('favorites');
    if (savedFavorites != null) {
      setState(() {
        favoriteRecipes = List<Map>.from(json.decode(savedFavorites));
      });
    }
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedFavorites = json.encode(favoriteRecipes);
    prefs.setString('favorites', encodedFavorites);
  }

  void toggleFavorite(Map recipe) {
    setState(() {
      if (favoriteRecipes.contains(recipe)) {
        favoriteRecipes.remove(recipe);
      } else {
        favoriteRecipes.add(recipe);
      }
    });
    saveFavorites();
  }

  void removeFavorite(int index) {
    setState(() {
      favoriteRecipes.removeAt(index);
    });
    saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade800, Colors.green.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(
                'Recipes',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteRecipesScreen(
                    favoriteRecipes: favoriteRecipes,
                    removeFavorite: removeFavorite,
                  ),
                ),
              ).then((_) {
                loadFavorites();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: recipes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  final isFavorite = favoriteRecipes.contains(recipe);

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15.0)),
                            child: Image.network(
                              recipe['image'] ??
                                  'https://via.placeholder.com/150',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    recipe['title'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    toggleFavorite(recipe);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
