import 'package:australti_ecommerce_app/models/profile.dart';
import 'package:australti_ecommerce_app/provider/store_provider.dart';
import 'package:australti_ecommerce_app/responses/store_response.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global/extension.dart';

class DataSearch extends SearchDelegate {
  String selection = '';
  final usersProvider = new StoresProvider();
  final Profile userAuth;

  DataSearch({this.userAuth});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final ThemeData theme =
        (currentTheme.customTheme) ? ThemeData.dark() : ThemeData.light();
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              color: (currentTheme.customTheme)
                  ? Colors.white54
                  : Colors.black54)),
      primaryColor: (currentTheme.customTheme) ? Colors.black : Colors.white,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  String get searchFieldLabel => 'Buscar club o tratamiento';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.grey),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Colors.grey,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Text(
              selection,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    if (query.isEmpty && query.length < 3) {
      return Scaffold(
          backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
          body: Container());
    }

    return Scaffold(
      backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
      body: FutureBuilder(
        future: usersProvider.getSearchPrincipalByQuery(query),
        builder:
            (BuildContext context, AsyncSnapshot<StoresResponse> snapshot) {
          if (snapshot.hasData) {
            final profiles = snapshot.data.stores;

            return ListView(
              children: profiles.map((profile) {
                return Hero(
                  tag: profile.user.uid,
                  child: ListTile(
                    tileColor: (currentTheme.customTheme)
                        ? currentTheme.currentTheme.cardColor
                        : Colors.white,
                    leading: Container(),
                    title: Text(
                      profile.name.capitalize(),
                      style: TextStyle(
                          color: (currentTheme.customTheme)
                              ? Colors.white
                              : Colors.black),
                    ),
                    subtitle: Text(
                      '@' + profile.user.username,
                      style: TextStyle(
                          color: (currentTheme.customTheme)
                              ? Colors.white54
                              : Colors.black54),
                    ),
                    onTap: () {
                      close(context, null);
                      //profile.user.uid = '';
                      //Navigator.pushNamed(context, 'detail', arguments: profile);

                      if (profile.user.uid != this.userAuth.user.uid) {
                        //Provider.of<ChatService>(context, listen: false);
                        //chatService.userFor = profile;
                        //Navigator.push(context, createRouteProfile(profile));
                      } else {
                        // Navigator.push(context, createRoute());
                      }
                    },
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(
              child: buildLoadingWidget(context),
            );
          }
        },
      ),
    );
  }
}
