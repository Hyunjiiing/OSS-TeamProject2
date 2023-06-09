import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class Recipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RecipeSearchPage(),
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
  Color _ingredientIconColor = Colors.grey;

  void searchRecipesByIngredient() async {
    String ingredient = _ingredientController.text;

    if (ingredient.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('검색할 재료를 입력해주세요.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

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

  void getRecipeDetails(String recipeName) async {
    var response = await http.get(Uri.parse('http://openapi.foodsafetykorea.go.kr/api/2190a55f6c5d400d9e23/COOKRCP01/xml/1/1000'));

    if (response.statusCode == 200) {
      var xmlData = response.body;
      var document = xml.XmlDocument.parse(xmlData);
      var recipeElements = document.findAllElements('row');

      for (var recipeElement in recipeElements) {
        var name = recipeElement.findElements('RCP_NM').first.text;
        if (name == recipeName) {
          var details = '';
          for (int i = 1; i <= 10; i++) { // 최대 10개의 MANUAL 요소 확인
            var manualElement = recipeElement.findElements('MANUAL${i.toString().padLeft(2, '0')}').first;
            if (manualElement != null) {
              var manualText = manualElement.text.replaceAll('<br />', '\n');
              details += manualText.replaceAll(RegExp(r'^\d+.\s'), '') + '\n\n';
            } else {
              break; // MANUAL 요소가 없으면 종료
            }
          }
          setState(() {
            _selectedRecipe = name;
            _recipeDetails = details;
          });
          break;
        }
      }
    } else {
      print('레시피 검색에 실패했습니다: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                labelText: '재료를 입력하세요',
                labelStyle: TextStyle(
                  color: Colors.black, // 원래 색상
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // 원래 색상
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF923F), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: _ingredientIconColor,
                ),
              ),
              cursorColor: Color(0xFFFF923F),
              onTap: () {
                setState(() {
                  _ingredientController.text.isNotEmpty
                      ? _ingredientController.clear()
                      : _ingredientController.text = '';

                  _ingredientIconColor = _ingredientController.text.isNotEmpty ? Color(0xFFFF923F) : Colors.grey;
                });
              },
            ),

            ElevatedButton(
              onPressed: searchRecipesByIngredient,
              child: Text(
                '검색',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFF923F),
                padding: EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              _matchingRecipes.isEmpty ? '' : '입력한 재료를 포함하는 레시피:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _matchingRecipes.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Icon(
                            _matchingRecipes[index] == _selectedRecipe ? Icons.check : null,
                            color: _matchingRecipes[index] == _selectedRecipe ? Color(0xFFFF923F) : Colors.transparent,
                          ),
                          SizedBox(width: 8.0),
                          Text(_matchingRecipes[index]),
                        ],
                      ),
                      onTap: () => getRecipeDetails(_matchingRecipes[index]),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8.0),
              ),
            ),
            if (_selectedRecipe.isNotEmpty) ...[
              SizedBox(height: 16.0),
              Text(
                '$_selectedRecipe 레시피 상세:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF923F),
                ),
              ),
              SizedBox(height: 8.0),
              Text(_recipeDetails),
            ],
          ],
        ),
      ),
    );
  }
}
