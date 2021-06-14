import 'package:australti_ecommerce_app/pages/principal_home_page.dart';
import 'package:australti_ecommerce_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  final VoidCallback onSkip;

  const Header({
    @required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () {
                final menuBloc = Provider.of<MenuModel>(context, listen: false);
                menuBloc.currentPage = 0;
                Navigator.push(context, principalHomeRoute());
              },
              icon: Icon(
                Icons.chevron_left,
                size: 40,
              )),
        ),

        /*  const Logo(
          color: Colors.white,
          size: 32.0,
        ), */
        GestureDetector(
          onTap: onSkip,
          child: Text(
            'Skip',
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
