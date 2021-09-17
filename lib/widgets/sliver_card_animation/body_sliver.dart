import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freeily/models/store.dart';
import 'package:freeily/profile_store.dart/profile_store_user.dart';
import 'package:freeily/routes/routes.dart';
import 'package:freeily/theme/theme.dart';
import 'package:freeily/widgets/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../elevated_button_style.dart';

class Body extends StatelessWidget {
  const Body(
      {Key key,
      @required this.store,
      @required this.size,
      @required this.isAuth})
      : super(key: key);

  final Size size;
  final Store store;
  final bool isAuth;
  @override
  Widget build(BuildContext context) {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;
    final instagramStore = store.instagram.toString();

    final emailStore = store.user.email.toString();

    _launchMessageEmail(String email) async {
      final url = Uri.encodeFull('mailto:$email?subject=Hola&body=Mensage');
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Container(
        padding: EdgeInsets.only(top: 0, bottom: 10),
        color: currentTheme.scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isAuth)
              Container(
                padding: EdgeInsets.only(left: 16.5),
                child: elevatedButtonCustom(
                    context: context,
                    title: 'Editar perfil',
                    onPress: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(context, profileEditRoute());
                    },
                    isEdit: true,
                    isDelete: false),
              ),
            if (!isAuth)
              Container(
                  padding: EdgeInsets.only(left: 16.5),
                  child: ButtonFollow(store: store, left: size.width)),
            if (emailStore != "")
              Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 120,
                  height: 35,
                  child: elevatedButtonCustom(
                      context: context,
                      title: 'Email',
                      onPress: () {
                        HapticFeedback.lightImpact();
                        _launchMessageEmail(store.user.email);
                      },
                      isEdit: true,
                      isDelete: false,
                      isAccent: false)),
            if (instagramStore != "")
              Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 120,
                  height: 35,
                  child: elevatedButtonCustom(
                      context: context,
                      title: 'Contacto',
                      onPress: () {
                        HapticFeedback.lightImpact();

                        showContactOptionsStoreMCBottomSheet(context, store);
                      },
                      isEdit: true,
                      isDelete: false,
                      isAccent: false)),
          ],
        ));
  }
}
