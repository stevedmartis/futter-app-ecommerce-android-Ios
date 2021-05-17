import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
