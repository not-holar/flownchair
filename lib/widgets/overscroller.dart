import 'package:flutter/material.dart';

typedef OverscrollerTestFunction = bool Function(ScrollMetrics metrics);

class Overscroller extends StatefulWidget {
  const Overscroller({
    Key? key,
    required this.test,
    required this.onOverscroll,
    required this.child,
  }) : super(key: key);

  final OverscrollerTestFunction test;
  final void Function() onOverscroll;
  final Widget child;

  @override
  _OverscrollerState createState() => _OverscrollerState();
}

class _OverscrollerState extends State<Overscroller> {
  /// Whether the previous position of the scroll controller passed the
  /// activation test, it's needed so that [widget.onOverscrolled] is only called
  /// once per pass
  bool _previouslyPassed = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          final passed = widget.test(notification.metrics);

          if (passed != _previouslyPassed) {
            if (passed) widget.onOverscroll();

            _previouslyPassed = passed;
          }
        }
        return false;
      },
      child: widget.child,
    );
  }
}
