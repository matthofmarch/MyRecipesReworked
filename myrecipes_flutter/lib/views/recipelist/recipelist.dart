import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:models/model.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeList extends StatefulWidget {
  final List<Recipe> _recipes;

  const RecipeList(this._recipes) : super();
  @override
  _RecipeListState createState() => _RecipeListState(_recipes);
}

class _RecipeListState extends State<RecipeList> {
  List<Recipe> _recipes;
  _RecipeListState(this._recipes);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onLongPress: () async {
                  try{
                    final res = await RepositoryProvider.of<RecipeRepository>(context).delete(recipe.id);
                    if(res){
                      setState(() {
                        _recipes.removeAt(index);
                      });
                      Fluttertoast.showToast(
                          msg: "Deleted Recipe",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Theme.of(context).primaryColorLight,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  } catch(e){

                  }
                },
              child: Card(
                child: Column(
                  children: [
                    if (recipe.image != null) Builder(builder: (context) {
                      final image = CachedNetworkImage(
                        imageUrl: recipe.image,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => Text("When I grow up, I want to be an Image"),
                        errorWidget: (context, url, error) => Container(),
                      );

                      return image != null ?
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4, left: 4, right: 4),
                        child: AspectRatio(
                            aspectRatio: 3 / 2,
                            child: image
                        ),
                      ):Text("Image not available");


                    }),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Text(recipe.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6,
                                  maxLines: 2)),
                          Row(
                            children: [
                              Icon(PlatformIcons(context).clockSolid),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                  "${recipe.cookingTimeInMin} Minutes"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
