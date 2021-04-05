import 'package:flutter/material.dart';
import 'package:australti_feriafy_app/dbrand_skin_selection/dbrand_skin.dart';

class DbrandSkinSelection extends StatefulWidget {
  @override
  _DbrandSkinSelectionState createState() => _DbrandSkinSelectionState();
}

class _DbrandSkinSelectionState extends State<DbrandSkinSelection>
    with SingleTickerProviderStateMixin {
  DbrandSkin _current = skins.first;
  DbrandSkin _past = skins.last;
  AnimationController _controller;

  void _onSkinSelected(DbrandSkin skin) {
    setState(() {
      _current = skin;
    });
    _controller.forward(from: 0.0).whenComplete(() {
      setState(() {
        _past = _current;
      });
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      upperBound: 2.5,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DBrand Skin selection'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset(
                    _past.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return ClipPath(
                        clipper: _SkinClipper(
                          _controller.value,
                          _current,
                        ),
                        child: Image.asset(
                          _current.image,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  '${_current.name}',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.white,
                      ),
                ),
                Expanded(
                  child: GridView.builder(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: skins.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                      ),
                      itemBuilder: (context, index) {
                        return _SkinButton(
                          skin: skins[index],
                          selected: _current.color == skins[index].color,
                          onTap: () {
                            _onSkinSelected(skins[index]);
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkinClipper extends CustomClipper<Path> {
  _SkinClipper(this.percent, this.skin);
  final double percent;
  final DbrandSkin skin;

  @override
  Path getClip(Size size) {
    final path = Path();
    Offset center;
    if (skin.center == Alignment.center) {
      center = Offset(size.width / 2, size.height / 2);
    } else if (skin.center == Alignment.bottomCenter) {
      center = Offset(size.width / 2, size.height);
    } else if (skin.center == Alignment.bottomLeft) {
      center = Offset(0, size.height);
    } else if (skin.center == Alignment.bottomRight) {
      center = Offset(size.width, size.height);
    } else if (skin.center == Alignment.centerRight) {
      center = Offset(size.width, size.height / 2);
    } else if (skin.center == Alignment.topRight) {
      center = Offset(size.width, 0.0);
    } else if (skin.center == Alignment.topCenter) {
      center = Offset(size.width / 2, 0.0);
    } else if (skin.center == Alignment.topLeft) {
      center = Offset(0.0, 0.0);
    }

    path.addOval(Rect.fromCenter(
      center: center,
      width: size.width * percent,
      height: size.height * percent,
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _SkinButton extends StatelessWidget {
  const _SkinButton({
    Key key,
    this.skin,
    this.onTap,
    this.selected = false,
  }) : super(key: key);
  final DbrandSkin skin;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: selected ? 8.0 : 1.0,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(skin.color),
          ),
        ),
      ),
    );
  }
}
