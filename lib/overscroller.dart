import 'package:flutter/material.dart';

class Overscroller extends StatefulWidget {
  const Overscroller({
    Key? key,
    this.controller,
    required this.test,
    required this.onOverscrolled,
    required this.child,
  }) : super(key: key);

  final bool Function(double offset) test;
  final void Function() onOverscrolled;
  final Widget child;
  final ScrollController? controller;

  @override
  _OverscrollerState createState() => _OverscrollerState();
}

class _OverscrollerState extends State<Overscroller> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return OverscrollerBase(
      key: const Key("Base"),
      controller: _controller,
      test: widget.test,
      onOverscrolled: widget.onOverscrolled,
      child: CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        clipBehavior: Clip.none,
        slivers: [
          SliverFillRemaining(child: widget.child),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();

    super.dispose();
  }
}

/// Overscroller's base widget, can be used individually with other scrollviews
class OverscrollerBase extends StatefulWidget {
  const OverscrollerBase({
    Key? key,
    required this.controller,
    required this.test,
    required this.onOverscrolled,
    required this.child,
  }) : super(key: key);

  final bool Function(double offset) test;
  final void Function() onOverscrolled;
  final Widget child;
  final ScrollController controller;

  @override
  _OverscrollerBaseState createState() => _OverscrollerBaseState();
}

class _OverscrollerBaseState extends State<OverscrollerBase> {
  /// Whether the previous position of the scroll controller passed the
  /// activation test, it's needed so that [widget.onOverscrolled] is only called
  /// once per pass
  bool _previouslyPassed = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      final passed = widget.test(widget.controller.offset);

      if (passed != _previouslyPassed) {
        if (passed) widget.onOverscrolled();

        _previouslyPassed = passed;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
