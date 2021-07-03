import 'package:flutter/material.dart';

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
                Navigator.pop(context);
                /* final menuBloc = Provider.of<MenuModel>(context, listen: false);
                menuBloc.currentPage = 0;
                Navigator.push(context, principalHomeRoute()); */
              },
              icon: Icon(
                Icons.chevron_left,
                size: 40,
                color: Colors.black,
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
                  color: Colors.black,
                ),
          ),
        ),
      ],
    );
  }
}
