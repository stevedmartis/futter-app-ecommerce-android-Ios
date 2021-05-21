import 'package:flutter/material.dart';

class ImagesProductSelector extends StatefulWidget {
  final List<Widget> pages;

  const ImagesProductSelector({
    Key key,
    this.pages,
  }) : super(key: key);

  @override
  _ImagesProductSelectorState createState() => _ImagesProductSelectorState();
}

class _ImagesProductSelectorState extends State<ImagesProductSelector> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // bool _isLastPage = widget.pages.length == this._currentPage + 1;

    Size _size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          width: _size.width,
          height: _size.height / 1.4,
          child: PageView(
            physics: ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                this._currentPage = page;
              });
            },
            children: widget.pages,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildPageIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    int numberOfPages = widget.pages.length;
    for (int i = 0; i < numberOfPages; i++) {
      list.add(_indicator(numberOfPages, i));
    }
    return list;
  }

  Widget _indicator(int numberOfPages, int index) {
    double _size;

    Color _color;

    if (_currentPage >= index - 0.5 && _currentPage < index + 0.5) {
      _size = 20;
      _color = Color(0xff34EC9C);
    } else {
      _size = 15;
      _color = Color(0xff1C181D);
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: _size,
      width: _size,
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: new BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.white.withOpacity(0.30),
            width: 1.5,
          ),
        ),
        child: Container(
          decoration: new BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class StyledLogoCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RichText(
          textAlign: TextAlign.center,
          text: new TextSpan(
            children: [
              TextSpan(
                text: "Leafety",
                style: TextStyle(
                  letterSpacing: -1,
                  fontFamily: 'GTWalsheimPro',
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
