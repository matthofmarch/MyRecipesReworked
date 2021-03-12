import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/theme.dart';

class UserSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth_repo = RepositoryProvider.of<AuthRepository>(context);
    var email = auth_repo.authState.email;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
            actions: [
              IconButton(icon: Icon(Icons.logout), onPressed: () {
                _showLogoutDialog(context);
              },)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle,size: 50,color: Theme.of(context).primaryColorDark,),
                    SizedBox(width: 5,),
                    Text(email,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ]
                ),
                SizedBox(height: 15,),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: shadowCards
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Account Settings",style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 30),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 80,
                                  child: Row(
                                    children: [
                                      Icon(Icons.vpn_key_outlined),
                                      SizedBox(width: 12,),
                                      Expanded(child: Text("Change Password",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).textTheme.headline4.color))),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey.shade300).color, width: 1)
                                      )
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.email_outlined),
                                      SizedBox(width: 12,),
                                      Expanded(child: Text("Change email",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).textTheme.headline4.color, fontSize: 20))),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: shadowCards,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Application Settings", style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 30),),
                          SizedBox(height: 12,),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.nights_stay_outlined),
                                    SizedBox(width: 8,),
                                    Expanded(child: Text("Dark Mode",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).textTheme.headline4.color))),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: MaterialButton(
                        onPressed: () {
                          //TODO implement leave Group functionallity
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Leave Group ",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                            Icon(
                              Icons.logout,
                              color: Theme.of(context).colorScheme.error,
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    )),
              ],
            ),
          )
        ),
      ],
    );
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
          MaterialButton(
            color: Theme.of(context).colorScheme.error,
            onPressed: () async {
              Navigator.of(context).pop();
              await RepositoryProvider.of<AuthRepository>(context).logout();
            },
            child: Text("Logout",
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white)),
          ),
        ],
      );
    },
  );
}