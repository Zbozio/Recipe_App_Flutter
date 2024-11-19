import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    var ingredients = recipe['extendedIngredients'] ?? [];

    String formatAmount(dynamic amount, String unit) {
      if (unit.isEmpty) return '$amount';
      return '$amount $unit';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        title: Text(
          recipe['title'],
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            letterSpacing: 1.5,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    recipe['image'] ?? 'https://via.placeholder.com/150',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  recipe['title'],
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  recipe['instructions'] ?? 'No instructions available.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                ingredients.isEmpty
                    ? const Text('No ingredients available.')
                    : Table(
                        border: TableBorder.all(color: Colors.black26),
                        columnWidths: const {
                          0: const FlexColumnWidth(2),
                          1: const FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                            ),
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Ingredient',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...ingredients.map<TableRow>((ingredient) {
                            String ingredientName =
                                ingredient['name'] ?? 'Unknown';
                            dynamic amount = ingredient['amount'] ?? 0.0;
                            String unit = ingredient['unit'] ?? '';

                            String formattedAmount = formatAmount(amount, unit);

                            return TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ingredientName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      formattedAmount,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
