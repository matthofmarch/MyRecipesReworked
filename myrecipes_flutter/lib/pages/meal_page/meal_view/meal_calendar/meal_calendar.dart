import 'dart:io';

import 'package:auth_repository/auth_repository.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/auth_guard/auth_guard.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/cubit/meal_view_cubit.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/views/vote_summary.dart';
import 'package:myrecipes_flutter/views/recipeDetails/recipe_detail.dart';
import 'package:myrecipes_flutter/views/util/NetworkOrDefaultImage.dart';
import 'package:myrecipes_flutter/views/util/RoundedImage.dart';

int kPageIndentation = 1000;

class MealCalendar extends StatelessWidget {
  List<Meal> meals;
  DateTime viewInitialDate;

  MealCalendar(List<Meal> meals, DateTime initialDate, {Key key})
      : super(key: key) {
    this.meals = meals;
    viewInitialDate = initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return PageView.custom(
      controller: PageController(
          viewportFraction:
              0.94 / ((MediaQuery.of(context).size.width ~/ 320) * 2 + 1),
          initialPage: kPageIndentation),
      onPageChanged: (newPageIndex) {
        BlocProvider.of<MealViewCubit>(context).currentDateSilent =
            viewInitialDate
                .add(Duration(days: newPageIndex - kPageIndentation));
      },
      childrenDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final indentedIndex = index - kPageIndentation;
          DateTime columnDate =
              viewInitialDate.add(Duration(days: indentedIndex));

          return Row(
            children: [
              VerticalDivider(
                indent: 20,
                endIndent: 20,
                width: 0, //Else one will see more of the most-left column than the one on the right
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Builder(
                      builder: (context) {
                        final mealsForDay = meals
                            .where((m) => mealOnCurrentDay(m, columnDate))
                            .map((m) => _mealCard(context, m))
                            .toList();

                        return ListView(
                          padding: EdgeInsets.only(top: 44),
                          children: mealsForDay.isNotEmpty ? mealsForDay : [Text("No meals", textAlign: TextAlign.center,)]
                        );
                      }
                    ),
                    _makeDateBadge(context, columnDate)
                  ],
                ),
              ),
            ],
          );
        },
      ),
      pageSnapping: true,
    );
  }

  mealOnCurrentDay(Meal meal, DateTime date) =>
      meal.date.isAfter(DateTime(date.year, date.month, date.day)) &&
      meal.date.isBefore(
          DateTime(date.year, date.month, date.day).add(Duration(days: 1)));

  Widget _mealCard(BuildContext context, Meal meal) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RecipeDetail(
              recipe: meal.recipe,
            ),
          ),
        );
      },
      onLongPress: () async {
        showBarModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Meal Actions",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(context.platformIcons.pen), Text("Delete")],
                ),
                SizedBox(height: 8,),
                if(RepositoryProvider.of<AuthRepository>(context).authState.isAdmin)
                PlatformButton(
                  onPressed: () {},
                  materialFlat: (context, platform) => MaterialFlatButtonData(),
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(context.platformIcons.checkMark), Text("Accept")],
                  ),
                )
              ],
            );
          },
        );
        return;
        await showCupertinoModalBottomSheet(
            context: context,
            builder: (context) {
              var title = Text(
                "Meal Actions",
                style: Theme.of(context).textTheme.subtitle1,
              );
              var mealActions = [
                PlatformButton(
                    materialFlat: (context, platform) =>
                        MaterialFlatButtonData(),
                    onPressed: () async {
                      //Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(context.platformIcons.pen),
                        Text("Vote up")
                      ],
                    )),
              ];

              var platformActionSheet = Platform.isIOS
                  ? CupertinoActionSheet(
                      title: title,
                      actions: [...mealActions],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: title,
                        ),
                        Divider(),
                        ...mealActions
                      ],
                    );
              return ModalBottomSheet(
                  onClosing: () {}, child: platformActionSheet);

              return BottomSheet(
                onClosing: () {},
                builder: (context) => platformActionSheet,
              );
            });

        await showPlatformModalSheet(
          context: context,
          builder: (context) {
            var title = Text(
              "Meal Actions",
              style: Theme.of(context).textTheme.subtitle1,
            );
            var mealActions = [
              PlatformButton(
                  materialFlat: (context, platform) => MaterialFlatButtonData(),
                  onPressed: () async {
                    //Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(context.platformIcons.pen),
                      Text("Vote up")
                    ],
                  )),
            ];

            var platformActionSheet = Platform.isIOS
                ? CupertinoActionSheet(
                    title: title,
                    actions: [...mealActions],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: title,
                      ),
                      Divider(),
                      ...mealActions
                    ],
                  );

            return BottomSheet(
              onClosing: () {},
              builder: (context) => platformActionSheet,
            );
          },
        );
      },
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Card(
          margin: EdgeInsets.all(4),
          //color: meal.accepted ? Theme.of(context).cardColor : Theme.of(context).cardColor.withAlpha(0x10),
          key: Key("meal-calendar-card_${meal.mealId}"),
          shadowColor: meal.accepted ? Colors.green : Colors.red,
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(2),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomAbrounding.image(
                    NetworkOrDefaultImage(meal.recipe.image),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VoteSummary(meal),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Proposed by jfd",
                                    style: Theme.of(context).textTheme.caption),
                                Text(
                                  "${meal.recipe.name}",
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _makeDateBadge(BuildContext context, DateTime columnDate) {
    return Badge(
      child: Chip(
        label: Text(
          DateFormat("E, d.").format(columnDate),
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        shape: StadiumBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        elevation: 5,
      ),
      position: BadgePosition.topEnd(top: 5.0, end: 5.0),
      badgeColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
