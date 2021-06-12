import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

showAlertError(BuildContext context, String titulo, String subtitulo) {
  bool isIos = UniversalPlatform.isIOS;
  bool isAndroid = UniversalPlatform.isAndroid;
  bool isWeb = UniversalPlatform.isWeb;
  if (isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                titulo,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(subtitulo, style: TextStyle(color: Colors.grey)),
              actions: <Widget>[
                MaterialButton(
                    child: Text('Aceptar'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  } else if (isIos || isWeb) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(titulo),
              content: Text(subtitulo),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Aceptar'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}

showSnackBar(BuildContext context, String text) {
  final currentTheme = Provider.of<ThemeChanger>(context, listen: false);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(text,
          style: TextStyle(
            color: (currentTheme.customTheme) ? Colors.white : Colors.white,
          ))));
}

showModalLoading(BuildContext context) {
  bool isIos = UniversalPlatform.isIOS;
  bool isAndroid = UniversalPlatform.isAndroid;
  bool isWeb = UniversalPlatform.isWeb;
  if (isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                content: Center(
              child: buildLoadingWidget(context),
            )));
  } else if (isIos || isWeb) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              content: Center(
                child: buildLoadingWidget(context),
              ),
            ));
  }
}
