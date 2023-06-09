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
  bool _isLoading = false;

  @override
  void dispose() {
    _ingredientController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  void searchRecipesByIngredient() async {
    setState(() {
      _isLoading = true;
      _selectedRecipe = '';
      _recipeDetails = '';
    });

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
        _isLoading = false;
      });
    } else {
      print('레시피 검색에 실패했습니다: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void getRecipeDetails(String recipeName) async {
    setState(() {
      _isLoading = true;
    });

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
            _isLoading = false;
          });
          break;
        }
      }
    } else {
      print('레시피 검색에 실패했습니다: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
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
              ),
              cursorColor: Color(0xFFFF923F),
            ),

            ElevatedButton(
              onPressed: _isLoading ? null : searchRecipesByIngredient,
              child: _isLoading
                  ? CircularProgressIndicator() // 로딩 인디케이터 표시
                  : Text(
                '검색',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFF923F),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '입력한 재료를 포함하는 레시피:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _matchingRecipes.length,
                itemBuilder: (context, index) {
                  return ListTile(
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
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            _selectedRecipe.isNotEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '레시피: $_selectedRecipe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '만드는 방법:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  height: 1.0,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                ),
                SizedBox(height: 8.0),
                Text(_recipeDetails),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
