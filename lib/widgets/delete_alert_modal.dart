import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

showAlertDeleteModalMatCup(String title, String subTitle, context) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;
  if (UniversalPlatform.isAndroid) {
    return AlertDialog(
      backgroundColor: currentTheme.cardColor,
      title: Text(
        'Eliminar Catalogo',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        'Seguro de realizar esta acción',
        style: TextStyle(color: Colors.white54),
      ),
      actions: <Widget>[
        TextButton(
            child: Text(
              'Eliminar',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            onPressed: () => {
                  Navigator.of(context).pop(true),
                }),
        TextButton(
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
            onPressed: () => {
                  Navigator.of(context).pop(false),
                }),
      ],
    );
  } else {
    return CupertinoAlertDialog(
      title: Text(
        'Eliminar Catalogo',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        'Seguro de realizar esta acción',
        style: TextStyle(color: Colors.white54),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(
            'Eliminar',
            style: TextStyle(color: currentTheme.accentColor),
          ),
          onPressed: () => {
            Navigator.of(context).pop(true),
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: false,
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () => {
            Navigator.of(context).pop(false),
          },
        ),
      ],
    );
  }
}

showAlertPermissionGpsModalMatCup(String title, String subTitle, String action,
    context, VoidCallback onPress, VoidCallback onCancel) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;

  if (UniversalPlatform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: currentTheme.cardColor,
              title: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                subTitle,
                style: TextStyle(color: Colors.white54),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                  onPressed: () => onCancel(),
                ),
                TextButton(
                    child: Text(
                      action,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    onPressed: () => onPress()),
              ],
            ));
  }

  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              subTitle,
              style: TextStyle(color: Colors.white54),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => onCancel(),
              ),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    action,
                    style: TextStyle(color: currentTheme.accentColor),
                  ),
                  onPressed: () => onPress()),
            ],
          ));
}
