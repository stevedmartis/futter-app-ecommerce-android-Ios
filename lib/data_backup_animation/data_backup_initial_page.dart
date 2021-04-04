import 'package:flutter/material.dart';
import 'package:youtube_diegoveloper_challenges/data_backup_animation/data_backup_home.dart';

const _duration = Duration(milliseconds: 500);

enum DataBackupState {
  initial,
  start,
  end,
}

class DataBackupInitialPage extends StatefulWidget {
  const DataBackupInitialPage({
    Key key,
    this.onAnimationStarted,
    this.progressAnimation,
  }) : super(key: key);
  final VoidCallback onAnimationStarted;
  final Animation<double> progressAnimation;

  @override
  _DataBackupInitialPageState createState() => _DataBackupInitialPageState();
}

class _DataBackupInitialPageState extends State<DataBackupInitialPage> {
  DataBackupState _currentState = DataBackupState.initial;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Cloud Storage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            if (_currentState == DataBackupState.end)
              Expanded(
                flex: 2,
                child: TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: _duration,
                  builder: (_, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'uploading files',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: ProgressCounter(
                              widget.progressAnimation,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_currentState != DataBackupState.end)
              Expanded(
                flex: 2,
                child: TweenAnimationBuilder(
                  tween: Tween(
                      begin: 1.0,
                      end:
                          _currentState != DataBackupState.initial ? 0.0 : 1.0),
                  duration: _duration,
                  onEnd: () {
                    setState(() {
                      _currentState = DataBackupState.end;
                    });
                  },
                  builder: (_, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(
                          0.0,
                          50 * value,
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text('last backup:'),
                      const SizedBox(height: 10),
                      Text(
                        '28 may 2020',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AnimatedSwitcher(
                duration: _duration,
                child: _currentState == DataBackupState.initial
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          /*  color: mainDataBackupColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), */

                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Create Backup',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentState = DataBackupState.start;
                            });
                            widget.onAnimationStarted();
                          },
                        ),
                      )
                    : OutlinedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 40),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: mainDataBackupColor,
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class ProgressCounter extends AnimatedWidget {
  ProgressCounter(Animation<double> animation) : super(listenable: animation);

  double get value => (listenable as Animation).value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(value * 100).truncate().toString()}%',
    );
  }
}
