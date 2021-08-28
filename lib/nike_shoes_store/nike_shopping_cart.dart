import 'package:flutter/material.dart';
import 'package:freeily/nike_shoes_store/nike_shoes.dart';

const _buttonSizeWidth = 200.0;
const _buttonSizeHeight = 60.0;
const _buttonCircularSize = 60.0;
const _finalImageSize = 30.0;
const _imageSize = 120.0;

class NikeShoppingCart extends StatefulWidget {
  final NikeShoes shoes;

  const NikeShoppingCart({Key key, @required this.shoes}) : super(key: key);

  @override
  _NikeShoppingCartState createState() => _NikeShoppingCartState();
}

class _NikeShoppingCartState extends State<NikeShoppingCart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animationResize;
  Animation _animationMovementIn;
  Animation _animationMovementOut;

  final _sizeSelected = ValueNotifier<int>(null);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animationResize = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.3,
        ),
      ),
    );
    _animationMovementIn = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.6),
      ),
    );
    _animationMovementOut = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.6,
          1.0,
          curve: Curves.elasticIn,
        ),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop(true);
      }
    });
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPanel() {
    final size = MediaQuery.of(context).size;
    final currentImageSize = (_imageSize * _animationResize.value)
        .clamp(_finalImageSize, _imageSize);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            0.0,
            value * size.height * 0.6,
          ),
          child: child,
        );
      },
      child: Container(
        height: (size.height * 0.6 * _animationResize.value).clamp(
          _buttonCircularSize,
          size.height * 0.6,
        ),
        width: (size.width * _animationResize.value)
            .clamp(_buttonCircularSize, size.width),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: _animationResize.value == 1
                ? Radius.circular(0)
                : Radius.circular(30),
            bottomRight: _animationResize.value == 1
                ? Radius.circular(0)
                : Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: _animationResize.value == 1
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset(
                    widget.shoes.images.first,
                    height: currentImageSize,
                  ),
                  if (_animationResize.value == 1) ...[
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            widget.shoes.model,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(.5),
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$${widget.shoes.currentPrice.toInt().toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
            if (_animationResize.value == 1) ...[
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Divider(
                  height: 2.5,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/nike_shoes_store/feet.png',
                    width: 30,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'SELECT SIZE',
                    style: TextStyle(
                      color: Colors.black.withOpacity(.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: widget.shoes.size.length,
                  itemBuilder: (_, i) => ValueListenableBuilder<int>(
                      valueListenable: _sizeSelected,
                      builder: (_, selected, __) {
                        return _ItemSelectSize(
                          text: widget.shoes.size[i],
                          color: (selected == i) ? Colors.black : null,
                          onTap: () => _sizeSelected.value = i,
                        );
                      }),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final buttonSizeWidth =
                (_buttonSizeWidth * _animationResize.value).clamp(
              _buttonCircularSize,
              _buttonSizeWidth,
            );
            final panelSizeWidth = (size.width * _animationResize.value)
                .clamp(_buttonCircularSize, size.width);
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.black87,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Stack(
                    children: <Widget>[
                      if (_animationMovementIn.value != 1)
                        Positioned(
                          top: size.height * 0.45 +
                              (_animationMovementIn.value * size.height * 0.45),
                          left: size.width / 2 - panelSizeWidth / 2,
                          width: panelSizeWidth,
                          child: _buildPanel(),
                        ),
                      Positioned(
                        bottom: 20 - (_animationMovementOut.value * 100),
                        left: size.width / 2 - buttonSizeWidth / 2,
                        child: TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                          tween: Tween(begin: 1.0, end: 0.0),
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(
                                0.0,
                                value * size.height * 0.6,
                              ),
                              child: child,
                            );
                          },
                          child: ValueListenableBuilder<int>(
                              valueListenable: _sizeSelected,
                              builder: (_, sizeSelected, __) {
                                return InkWell(
                                  onTap: (sizeSelected != null)
                                      ? () {
                                          _controller.forward();
                                        }
                                      : null,
                                  child: Container(
                                    width: buttonSizeWidth,
                                    height: (_buttonSizeHeight *
                                            _animationResize.value)
                                        .clamp(
                                      _buttonCircularSize,
                                      _buttonSizeHeight,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (sizeSelected != null)
                                          ? Colors.black
                                          : Colors.grey,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                            ),
                                          ),
                                          if (_animationResize.value == 1) ...[
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'ADD TO CART',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class _ItemSelectSize extends StatelessWidget {
  const _ItemSelectSize({
    Key key,
    @required this.text,
    @required this.color,
    @required this.onTap,
  }) : super(key: key);
  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 1, color: Colors.black54),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'US $text',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: (color != null) ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
