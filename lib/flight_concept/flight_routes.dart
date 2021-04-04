import 'package:flutter/material.dart';

class FlightRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE04148),
                    Color(0xFFD85774),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: BackButton(
              color: Colors.white,
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              children: <Widget>[
                RouteItem(
                  duration: const Duration(milliseconds: 400),
                ),
                RouteItem(
                  duration: const Duration(milliseconds: 600),
                ),
                RouteItem(
                  duration: const Duration(milliseconds: 800),
                ),
                RouteItem(
                  duration: const Duration(milliseconds: 1000),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RouteItem extends StatelessWidget {
  final Duration duration;

  const RouteItem({Key key, this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(end: 0.0, begin: 1.0),
      curve: Curves.decelerate,
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(
            0.0,
            MediaQuery.of(context).size.height * value,
          ),
          child: child,
        );
      },
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Sahara',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'SHE',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.flight,
                      color: Colors.red,
                    ),
                    Text(
                      'SE2341',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Macao',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'SHE',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
