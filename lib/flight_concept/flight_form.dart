import 'package:flutter/material.dart';

class FlightForm extends StatelessWidget {
  final VoidCallback onTap;

  const FlightForm({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.flight_takeoff,
                color: Colors.red,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'From'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.flight_land,
                color: Colors.red,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'To'),
                ),
              ),
            ],
          ),
          Spacer(),
          FloatingActionButton(
            onPressed: onTap,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.multiline_chart,
            ),
          ),
        ],
      ),
    );
  }
}
