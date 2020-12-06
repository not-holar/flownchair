import 'package:flutter/material.dart';

class Overscroller extends StatefulWidget {
  const Overscroller({
    Key? key,
    required this.test,
    required this.onOverscrolled,
    required this.child,
  }) : super(key: key);

  final bool Function(double offset) test;
  final void Function() onOverscrolled;
  final Widget child;

  @override
  _OverscrollerState createState() => _OverscrollerState();
}

class _OverscrollerState extends State<Overscroller> {
  late final _controller = ScrollController();

  /// Whether the previous position of the scroll controller passed the
  /// activation test, it's needed so that [widget.onOverscrolled] is only called
  /// once per pass
  bool _previouslyPassed = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final passed = widget.test(_controller.offset);

      if (passed != _previouslyPassed) {
        if (passed) widget.onOverscrolled();

        _previouslyPassed = passed;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      clipBehavior: Clip.none,
      slivers: [
        SliverFillRemaining(child: widget.child),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
