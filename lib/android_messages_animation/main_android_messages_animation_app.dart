import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MainAndroidMessagesAnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: AndroidMessagesAnimation(),
    );
  }
}

class AndroidMessagesAnimation extends StatefulWidget {
  @override
  _AndroidMessagesAnimationState createState() => _AndroidMessagesAnimationState();
}

class _AndroidMessagesAnimationState extends State<AndroidMessagesAnimation> {
  bool expanded = false;
  final scrollController = ScrollController();

  void _onScrollDirection() {
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse && expanded) {
      setState(() {
        expanded = false;
      });
    } else if (scrollController.position.userScrollDirection == ScrollDirection.forward && !expanded) {
      setState(() {
        expanded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _AndroidMessageFAB(
        expanded: expanded,
        onTap: () {},
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.search),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Text('Search conversations'),
                      ),
                    ),
                    Icon(Icons.more_vert_outlined),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (details) {
                  _onScrollDirection();

                  return true;
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    return _AndroidMessageItem(
                      color: Colors.primaries[index % Colors.primaries.length],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AndroidMessageItem extends StatelessWidget {
  const _AndroidMessageItem({Key key, this.color}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(
          Icons.person,
          color: Colors.black87,
        ),
      ),
      title: Text('515'),
      subtitle: Text('Hello world, welcome to Flutter'),
      trailing: Text('30 min'),
    );
  }
}

const _duration = Duration(milliseconds: 250);
const _minSize = 50.0;
const _iconSize = 24.0;

class _AndroidMessageFAB extends StatefulWidget {
  const _AndroidMessageFAB({
    Key key,
    this.expanded = false,
    this.onTap,
  }) : super(key: key);

  final bool expanded;
  final VoidCallback onTap;

  @override
  __AndroidMessageFABState createState() => __AndroidMessageFABState();
}

class __AndroidMessageFABState extends State<_AndroidMessageFAB> {
  double _maxSize = 150.0;
  final _keyText = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _maxSize = _keyText.currentContext.size.width + _minSize + _iconSize / 2;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final position = _minSize / 2 - _iconSize / 2;
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: _duration,
        width: widget.expanded ? _maxSize : _minSize,
        height: _minSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_minSize / 2),
          color: Colors.blue[800],
        ),
        child: Stack(
          children: [
            Positioned(
              left: position,
              top: position,
              child: Icon(
                Icons.message,
              ),
            ),
            Positioned(
              left: position + 1.5 * _iconSize,
              top: position,
              child: Text(
                'Start chat',
                key: _keyText,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
