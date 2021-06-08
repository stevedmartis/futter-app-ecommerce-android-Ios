import 'dart:ui';

import 'package:australti_ecommerce_app/bloc_globals/bloc_location/bloc/my_location_bloc.dart';
import 'package:australti_ecommerce_app/grocery_store/grocery_store_cart.dart';
import 'package:australti_ecommerce_app/models/place_Search.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

showMaterialCupertinoBottomSheet(
    BuildContext context, String titulo, String subtitulo) {
  if (UniversalPlatform.isIOS) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
          height: 500,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: GroceryStoreCart(
            cartHome: true,
          )),
    );
  } else if (UniversalPlatform.isAndroid) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Action One'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Action Two'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

showMaterialCupertinoBottomSheetLocation(BuildContext context, String titulo,
    String subtitulo, VoidCallback onPress, VoidCallback onCancel) {
  final currentTheme = Provider.of<ThemeChanger>(context, listen: false);
  final size = MediaQuery.of(context).size;

  if (UniversalPlatform.isIOS) {
    return showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => ClipRRect(
                child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 9.0,
                sigmaY: 9.0,
              ),
              child: Container(
                  height: size.height / 1.0,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        child: TextField(
                          style: TextStyle(
                            color: (currentTheme.currentTheme.accentColor),
                          ),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: (currentTheme.customTheme)
                                    ? Colors.white54
                                    : Colors.black54,
                              ),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: TextStyle(
                              color: (currentTheme.customTheme)
                                  ? Colors.white54
                                  : Colors.black54,
                            ),
                            // icon: Icon(Icons.perm_identity),
                            //  fillColor: currentTheme.accentColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: currentTheme.currentTheme.accentColor,
                                  width: 2.0),
                            ),
                            hintText: '',
                            labelText: 'Escribe tu dirección completa',

                            //counterText: snapshot.data,
                          ),
                          onChanged: (value) =>
                              myLocationBloc.searchPlaces(value),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<List<PlaceSearch>>(
                        stream: myLocationBloc.searchResults.stream,
                        builder: (context,
                            AsyncSnapshot<List<PlaceSearch>> snapshot) {
                          if (snapshot.hasData) {
                            final places = snapshot.data;

                            if (places.length > 0)
                              return Column(
                                children: [
                                  Container(
                                    child: ListView.builder(
                                        itemCount: places.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final place = places[index];
                                          return ListTile(
                                            onTap: () => {
                                              Navigator.push(
                                                  context,
                                                  confirmLocationImageRoute(
                                                      place)),
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode()),
                                            },
                                            title: Text(
                                              place.structuredFormatting
                                                  .mainText,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Text(
                                                  place.structuredFormatting
                                                      .secondaryText,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                  Container(
                                    child: Divider(
                                      height: 50,
                                    ),
                                  ),
                                ],
                              );

                            return Container();
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return Container();
                          }
                        },
                      ),

                      /* Expanded(
                          flex: 1,
                          child: elevatedButtonCustom(
                              context: context,
                              title: 'Continuar',
                              onPress: () {})), */
                      GestureDetector(
                        onTap: () => onPress(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.room_outlined,
                              size: 25,
                              color: currentTheme.currentTheme.accentColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Container(
                                child: Text(
                                  'Ubicación actual',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            )));
  } else if (UniversalPlatform.isAndroid) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Action One'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Action Two'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
