import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecipeSearchPage(),
    );
  }
}

class RecipeSearchPage extends StatefulWidget {
  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  final TextEditingController _ingredientController = TextEditingController();
  List<String> _matchingRecipes = [];
  String _selectedRecipe = '';
  String _recipeDetails = '';

  void searchRecipesByIngredient() async {
    String ingredient = _ingredientController.text;
  }
}
