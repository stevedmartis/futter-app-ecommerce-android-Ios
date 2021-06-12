import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';

class FeatureDiscoveryDemoApp extends StatefulWidget {
  @override
  _FeatureDiscoveryDemoAppState createState() =>
      _FeatureDiscoveryDemoAppState();
}

class _FeatureDiscoveryDemoAppState extends State<FeatureDiscoveryDemoApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>[
        'feature1',
        'feature2',
        'feature3',
        'feature4',
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feature Discovery Demo'),
        centerTitle: true,
        actions: [
          DescribedFeatureOverlay(
            featureId: 'feature3',
            targetColor: Colors.white,
            textColor: Colors.black,
            backgroundColor: Colors.amber,
            contentLocation: ContentLocation.trivial,
            title: Text(
              'More Icon',
              style: TextStyle(fontSize: 20.0),
            ),
            pulseDuration: Duration(seconds: 1),
            enablePulsingAnimation: true,
            barrierDismissible: false,
            overflowMode: OverflowMode.wrapBackground,
            openDuration: Duration(seconds: 1),
            description: Text('This is Button you can add more details heres'),
            tapTarget: Icon(Icons.search),
            child: IconButton(icon: Icon(Icons.search), onPressed: () {}),
            onOpen: () async {
              return true;
            },
          ),
        ],
      ),
      bottomNavigationBar: DescribedFeatureOverlay(
        featureId: 'feature1',
        targetColor: Colors.black,
        textColor: Colors.black,
        backgroundColor: Colors.red.shade100,
        contentLocation: ContentLocation.trivial,
        title: Text(
          'This is Button',
          style: TextStyle(fontSize: 20.0),
        ),
        pulseDuration: Duration(seconds: 1),
        enablePulsingAnimation: true,
        overflowMode: OverflowMode.extendBackground,
        openDuration: Duration(seconds: 1),
        description: Text('This is Button you can\n add more details heres'),
        tapTarget: Icon(Icons.navigation),
        child: BottomNavigationBar(items: [
          BottomNavigationBarItem(label: ('Home'), icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: ('Notification'), icon: Icon(Icons.notifications_active)),
        ]),
      ),
    );
  }
}
