import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_card.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_card_block_compact.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/vote_summary/vote_summary_big.dart';

import '../../../view_models/pages/meal_page/meals_cubit.dart';
import '../recipe_card.dart';

class PlannedMealsList extends StatefulWidget {
  final List<Meal> meals;
  final bool isLeaderboard;
  final MealsCubit mealsCubit;
  final BuildContext mealContext;
  Function(Meal) addToAccepted;
  Function(Meal) deleteFromUnaccepted;

  PlannedMealsList(this.mealsCubit,
      {@required this.meals, @required this.isLeaderboard, this.mealContext, this.addToAccepted,this.deleteFromUnaccepted});

  @override
  _PlannedMealsListState createState() => _PlannedMealsListState();
}

class _PlannedMealsListState extends State<PlannedMealsList> {
  var index = 1;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.isLeaderboard)
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(
            Icons.poll_outlined,
            size: 35,
          ),
          SizedBox(
            width: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              "Leaderboard",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ])
      else
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(
            Icons.star_border,
            size: 35,
          ),
          SizedBox(
            width: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              "Winners",
              style: Theme.of(context).textTheme.headline3,
            ),
          )
        ]),
      SizedBox(
        height: 16,
      ),
      if (widget.meals.isEmpty && !widget.isLeaderboard)
        Center(
            child: Text(
          "No Winner selected on this day!",
          style: Theme.of(context).textTheme.headline6,
        ))
      else if (widget.meals.isEmpty && widget.isLeaderboard)
        Center(
            child: Text(
          "No Suggestions for this day!",
          style: Theme.of(context).textTheme.headline6,
        ))
      else
        ...widget.meals.map((meal) {
          if (widget.isLeaderboard) {
            var res = Column(
              children: [
                Row(children: [
                  SizedBox(
                    width: 8,
                  ),
                  /*Container(
                      width: 30,
                      child: Text(
                        index.toString() + ".",
                        style: Theme.of(context).textTheme.headline4,
                      )),
                  SizedBox(
                    width: 10,
                  ),*/
                  Container(
                      width: 180,
                      height: 210,
                      child: RecipeCardBlockCompact(meal.recipe)),
                  SizedBox(
                    width: 20,
                  ),
                  VoteSummaryBig(widget.mealsCubit, meal)
                ]),
                SizedBox(
                  height: 16,
                ),
                RepositoryProvider.of<AuthRepository>(context)
                    .authState
                    .isAdmin ?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          height: 40,
                          minWidth: 30,
                          color: Colors.grey.shade100,
                          onPressed: () async {
                            await RepositoryProvider.of<MealRepository>(widget.mealContext).acceptMealProposal(meal.mealId, true);
                            await widget.mealsCubit.load();
                            setState(() {
                              widget.addToAccepted(meal);
                              widget.meals.remove(meal);
                            });
                          },
                          child: Row(mainAxisAlignment: MainAxisAlignment.center ,children: [
                            Icon(Icons.check_circle, color:Theme.of(context).primaryColor),
                            SizedBox(width: 3,),
                            Text("Accept",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).primaryColor,fontSize: 18)),
                          ]),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: MaterialButton(
                          height: 40,
                          minWidth: 30,
                          color: Colors.grey.shade100,
                          onPressed: () async {
                            try{
                              await RepositoryProvider.of<MealRepository>(context).deleteMealById(meal.mealId);
                            }catch(Exception){

                            }
                            await widget.mealsCubit.load();
                            setState(() {
                              widget.deleteFromUnaccepted(meal);
                              widget.meals.remove(meal);
                            });                          },
                          child: Row(mainAxisAlignment: MainAxisAlignment.center ,children: [
                            Icon(Icons.delete_forever_outlined, color:Theme.of(context).colorScheme.error),
                            SizedBox(width: 3,),
                            Text("Delete",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).colorScheme.error,fontSize: 18)),
                          ]),
                        ),
                      )
                    ]
                  ),
                ): Container(),
                SizedBox(
                  height: 16,
                ),
              ],
            );
            index++;
            return res;
          } else {
            return Column(children: [
              RecipeCard(meal.recipe),
              SizedBox(
                height: 16,
              )
            ]);
          }
        }),
      SizedBox(
        height: 16,
      ),
      if (!widget.isLeaderboard)
        Center(
            child: Icon(
          Icons.keyboard_arrow_down,
          size: 30,
        )),
      /*Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Icon(
          Icons.poll_outlined,
          size: 35,
        ),
        SizedBox(
          width: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text(
            "Leaderboard",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ]),
      SizedBox(
        height: 16,
      ),*/
    ]);
  }
}
