import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/pages/home_page/invite_card.dart';
import 'package:myrecipes_flutter/views/appbar/CustomDefaultAppBar.dart';
import 'package:myrecipes_flutter/views/members/memberships.dart';

import 'invite_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomDefaultAppBar(title:Text("Household")),
        body: ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            MembershipsView(),
            SizedBox(height: 8,),
            InviteCodeCard(),
            SizedBox(
              height: 8,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: OutlineButton(
                    onPressed: () => _showLogoutDialog(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Logout ",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Theme.of(context).colorScheme.error),
                        ),
                        Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.error,
                        )
                      ],
                    ),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                )),
          ],
        ));
  }

  void _showLogoutDialog(BuildContext context) => showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Log out?"),
            content: Text(
                'Do you really want to be logged out? You will be redirected to the login screen.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "No",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
              OutlinedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await RepositoryProvider.of<AuthRepository>(context).logout();
                },
                child: Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1),
              ),
            ],
          );
        },
      );
}
