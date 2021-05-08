import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/nike_shoes_store/nike_shoes.dart';
import 'package:australti_ecommerce_app/nike_shoes_store/nike_shopping_cart.dart';
import 'package:australti_ecommerce_app/nike_shoes_store/page_indicator_painter.dart';
import 'package:australti_ecommerce_app/transitions/shake_transition.dart';

class NikeShoesDetails extends StatefulWidget {
  final NikeShoes shoes;

  NikeShoesDetails({Key key, @required this.shoes}) : super(key: key);

  @override
  _NikeShoesDetailsState createState() => _NikeShoesDetailsState();
}

class _NikeShoesDetailsState extends State<NikeShoesDetails> {
  PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  final ValueNotifier<bool> notifierButtonsVisible = ValueNotifier(false);

  Future<void> _openShoppingCart(BuildContext context) async {
    notifierButtonsVisible.value = false;
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, animation1, __) {
          return FadeTransition(
            opacity: animation1,
            child: NikeShoppingCart(
              shoes: widget.shoes,
            ),
          );
        },
      ),
    );
    notifierButtonsVisible.value = true;
  }

  Widget _buildCarousel(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.5,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Hero(
              tag: 'background_${widget.shoes.model}',
              child: Container(
                color: Color(widget.shoes.color),
              ),
            ),
          ),
          Positioned(
            left: 70,
            right: 70,
            top: 10,
            child: Hero(
              tag: 'number_${widget.shoes.model}',
              child: ShakeTransition(
                axis: Axis.vertical,
                duration: const Duration(milliseconds: 1400),
                offset: 15,
                child: Material(
                  color: Colors.transparent,
                  child: FittedBox(
                    child: Text(
                      widget.shoes.modelNumber.toString(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.05),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ShakeTransition(
            axis: Axis.vertical,
            offset: 100,
            child: PageView.builder(
                itemCount: widget.shoes.images.length,
                controller: _controller,
                itemBuilder: (context, index) {
                  final tag = index == 0
                      ? 'image_${widget.shoes.model}'
                      : 'image_${widget.shoes.model}_$index';
                  return Container(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: tag,
                      child: Image.asset(
                        widget.shoes.images[index],
                        height: 200,
                        width: 200,
                      ),
                    ),
                  );
                }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => CustomPaint(
                  painter: PageIndicatorPainter(
                    pageCount: widget.shoes.images.length,
                    scrollPosition:
                        (_controller.hasClients && _controller.page != null)
                            ? _controller.page
                            : 0.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifierButtonsVisible.value = true;
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/nike_shoes_store/nike_logo.png',
          height: 40,
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildCarousel(context),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ShakeTransition(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.shoes.model,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                                maxLines: 2,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      '\$${widget.shoes.oldPrice.toInt().toString()}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '\$${widget.shoes.currentPrice.toInt().toString()}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ShakeTransition(
                          duration: const Duration(milliseconds: 1100),
                          child: Text(
                            'AVAILABLE SIZES',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(.7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ShakeTransition(
                          duration: const Duration(milliseconds: 1100),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: widget.shoes.size
                                  .map((size) => _ShoeSizeItem(
                                        text: size,
                                      ))
                                  .toList()),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'DESCRIPTION',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.shoes.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: notifierButtonsVisible,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    FloatingActionButton(
                        heroTag: 'fav_1',
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.black,
                        ),
                        onPressed: () {}),
                    Spacer(),
                    FloatingActionButton(
                      heroTag: 'fav_2',
                      backgroundColor: Colors.black,
                      child: Icon(Icons.shopping_basket),
                      onPressed: () {
                        _openShoppingCart(context);
                      },
                    ),
                  ],
                ),
              ),
              builder: (context, value, child) {
                return AnimatedPositioned(
                  left: 0,
                  right: 0,
                  bottom: value ? 0.0 : -kToolbarHeight * 1.5,
                  duration: const Duration(milliseconds: 250),
                  child: child,
                );
              }),
        ],
      ),
    );
  }
}

class _ShoeSizeItem extends StatelessWidget {
  final String text;

  const _ShoeSizeItem({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        'US $text',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
