import 'package:flutter/material.dart';
import 'package:australti_ecommerce_app/multiple_card_flow/place.dart';

import 'multiple_card_flow.dart';

class MultipleCardFlowDetails extends StatelessWidget {
  const MultipleCardFlowDetails({Key key, this.city}) : super(key: key);

  final City city;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: backgroundGradient,
              ),
            ),
          ),
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: CityWidget(
                      city: city,
                      padding: EdgeInsets.only(left: 40, top: 40),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ListView.builder(
                        itemCount: city.reviews.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final review = city.reviews[index];
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ReviewWidget(
                              review: review,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
