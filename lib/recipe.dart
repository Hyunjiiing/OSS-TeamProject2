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

    var response = await http.get(Uri.parse('http://openapi.foodsafetykorea.go.kr/api/2190a55f6c5d400d9e23/COOKRCP01/xml/1/50'));

    if (response.statusCode == 200) {
      var xmlData = response.body;
      var document = xml.XmlDocument.parse(xmlData);
      var recipeElements = document.findAllElements('row');

      List<String> matchingRecipes = [];
      for (var recipeElement in recipeElements) {
        var ingredients = recipeElement.findElements('RCP_PARTS_DTLS').first.text;
        if (ingredients.contains(ingredient)) {
          var recipeName = recipeElement.findElements('RCP_NM').first.text;
          matchingRecipes.add(recipeName);
        }
      }

      setState(() {
        _matchingRecipes = matchingRecipes;
        _selectedRecipe = '';
        _recipeDetails = '';
      });
    } else {
      print('레시피 검색에 실패했습니다: ${response.statusCode}');
    }
  }
  }
}
