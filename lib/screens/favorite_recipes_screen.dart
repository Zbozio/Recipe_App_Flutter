import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  final List<Map> favoriteRecipes;
  final Function(int) removeFavorite;

  const FavoriteRecipesScreen(
      {super.key, required this.favoriteRecipes, required this.removeFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(child: Text('No favorite recipes yet.'))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(recipe['title']),
                    leading: Image.network(
                      recipe['image'] ?? 'https://via.placeholder.com/150',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        removeFavorite(index);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
