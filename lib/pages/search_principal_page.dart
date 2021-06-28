import 'package:australti_ecommerce_app/sockets/socket_connection.dart';
import 'package:australti_ecommerce_app/store_principal/store_principal_home.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class SearchPrincipalPage extends StatefulWidget {
  @override
  _SearchPrincipalPageState createState() => _SearchPrincipalPageState();
}

class _SearchPrincipalPageState extends State<SearchPrincipalPage> {
  SocketService socketService;

  bool loading = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ScrollController _scrollController;

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  /*  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 70;
  } */

  final textCtrl = TextEditingController();

  FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    // final roomsModel = Provider.of<Room>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: <Widget>[
                makeHeaderCustom('Mis Catalogos'),

                //makeListProducts(context)
              ]),
        ),
      ),
    );
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    //final catalogo = new ProfileStoreCategory();
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: currentTheme.currentTheme.cardColor),
                      child: Row(
                        children: [
                          Material(
                            color: currentTheme.currentTheme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              splashColor: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              radius: 30,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              highlightColor: Colors.grey,
                              child: Container(
                                width: 34,
                                height: 34,
                                child: Icon(
                                  Icons.chevron_left,
                                  color: currentTheme.currentTheme.accentColor,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: size.width,
                            height: 40,
                            decoration: BoxDecoration(
                                color: currentTheme.currentTheme.cardColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 20),
                                      child: TextField(
                                        style: TextStyle(color: Colors.white),
                                        inputFormatters: [
                                          new LengthLimitingTextInputFormatter(
                                              100),
                                        ],
                                        focusNode: _focusNode,
                                        autofocus: true,
                                        controller: textCtrl,
                                        //  keyboardType: TextInputType.emailAddress,

                                        maxLines: 1,

                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: currentTheme
                                                    .currentTheme.cardColor),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.white54),
                                          // icon: Icon(Icons.perm_identity),
                                          //  fillColor: currentTheme.accentColor,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: currentTheme
                                                    .currentTheme.cardColor,
                                                width: 0.0),
                                          ),
                                          hintText: '',
                                          //  labelText: 'Buscar ...',
                                          //counterText: snapshot.data,
                                          //  errorText: snapshot.error
                                        ),
                                        //onChanged: productBloc.changeDescription,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: ShapeDecoration(
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.50),
                                                offset: Offset(3.0, 3.0),
                                                blurRadius: 2.0,
                                                spreadRadius: 1.0,
                                              )
                                            ],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            gradient: LinearGradient(
                                                colors: gradients,
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight),
                                          ),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ))),
                    SizedBox(width: 10),
                  ],
                ))));
  }
}
