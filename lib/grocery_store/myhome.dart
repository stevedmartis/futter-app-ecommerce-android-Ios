import 'package:flutter/material.dart';

class MyHomePage1 extends StatefulWidget {
  MyHomePage1({Key key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CustomMultiChildLayout(
          delegate: YourLayoutDelegate(),
          children: <Widget>[
            LayoutId(
              id: 1, // The id can be anything, i.e. any Object, also an enum value.
              child: Text(
                  'Widget one'), // This is the widget you actually want to show.
            ),
            LayoutId(
              id: 2, // You will need to refer to that id when laying out your children.
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Widget two'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YourLayoutDelegate extends MultiChildLayoutDelegate {
  // You can pass any parameters to this class because you will instantiate your delegate
  // in the build function where you place your CustomMultiChildLayout.
  // I will use an Offset for this simple example.

  YourLayoutDelegate({this.position});

  final Offset position;

  @override
  void performLayout(Size size) {
    // `size` is the size of the `CustomMultiChildLayout` itself.

    Size leadingSize = Size
        .zero; // If there is no widget with id `1`, the size will remain at zero.
    // Remember that `1` here can be any **id** - you specify them using LayoutId.
    if (hasChild(1)) {
      leadingSize = layoutChild(
        1, // The id once again.
        BoxConstraints.tightFor(
            height: size
                .height), // This just says that the child cannot be bigger than the whole layout.
      );
      // No need to position this child if we want to have it at Offset(0, 0).
    }

    if (hasChild(2)) {
      final secondSize = layoutChild(
        2,
        BoxConstraints.tightFor(width: size.width / 2),
      );

      positionChild(
        2,
        Offset(
          leadingSize.width, // This will place child 2 to the right of child 1.
          size.height / 2 -
              secondSize.height / 2, // Centers the second child vertically.
        ),
      );
    }
  }

  @override
  bool shouldRelayout(YourLayoutDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
