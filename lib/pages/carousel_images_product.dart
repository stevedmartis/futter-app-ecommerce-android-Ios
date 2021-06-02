import 'package:australti_ecommerce_app/controller/slide_controller.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/material.dart';

class CarouselImagesProduct extends StatefulWidget {
  CarouselImagesProduct({this.images});
  final List<ImageProduct> images;
  @override
  _CarouselImagesProductState createState() => _CarouselImagesProductState();
}

class _CarouselImagesProductState extends State<CarouselImagesProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
          return AnimatedContainer(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1C181D),
                    Colors.black,
                  ],
                  stops: [0, 1],
                  begin: Alignment(-0.00, -5.00),
                  end: Alignment(0.00, 5.00),
                ),
              ),
              duration: Duration(milliseconds: 500),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500, minWidth: 500),
                  child: ImagesProductSelector(
                      pages: List.generate(
                    widget.images.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.network(
                        widget.images[index].url,
                        fit: BoxFit.contain,
                        height: MediaQuery.of(context).size.height * 0.36,
                      ),
                    ),
                  )),
                ),
              ));
        })));
  }
}
