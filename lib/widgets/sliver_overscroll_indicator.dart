// Forked from flutter/SliverOverscrollIndicator

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Signature for a builder that can create a different widget to show in the
/// refresh indicator space depending on the space available.
///
/// The `pulledExtent` parameter is the currently available space either from
/// overscrolling or as held by the sliver during refresh.
typedef OverscrollIndicatorBuilder = Widget Function(
  BuildContext context,
  double pulledExtent,
);

/// Simply draws a widget inside of the overscroll area
/// Forked from flutter/SliverOverscrollIndicator
class SliverOverscrollIndicator extends StatefulWidget {
  /// The [refreshTriggerPullDistance] and [refreshIndicatorExtent] arguments
  /// must not be null and must be >= 0.
  ///
  /// The [builder] argument may be null, in which case no indicator UI will be
  /// shown but the [onRefresh] will still be invoked. By default, [builder]
  /// shows a [CupertinoActivityIndicator].

  const SliverOverscrollIndicator({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// The amount of overscroll the scrollable must be dragged to trigger a reload.
  ///
  /// Must not be null, must be larger than 0.0 and larger than
  /// [refreshIndicatorExtent]. Defaults to 100px when not specified.
  ///
  /// When overscrolled past this distance, [onRefresh] will be called if not
  /// null and the [builder] will build in the [RefreshIndicatorMode.armed] state.
  static const double refreshTriggerPullDistance = double.infinity;

  /// A builder that's called as this sliver's size changes, and as the state
  /// changes.
  ///
  /// Can be set to null, in which case nothing will be drawn in the overscrolled
  /// space.
  ///
  /// Will not be called when the available space is zero such as before any
  /// overscroll.
  final OverscrollIndicatorBuilder? builder;

  @override
  _SliverOverscrollIndicatorState createState() =>
      _SliverOverscrollIndicatorState();
}

class _SliverOverscrollIndicatorState extends State<SliverOverscrollIndicator> {
  // The amount of space available from the inner indicator box's perspective.
  //
  // The value is the sum of the sliver's layout extent and the overscroll
  //
  // The value of latestIndicatorBoxExtent doesn't change when the sliver scrolls
  // away without retracting; it is independent from the sliver's scrollOffset.
  double latestIndicatorBoxExtent = 0.0;

  @override
  Widget build(BuildContext context) {
    return _SliverOverscroll(
      // A LayoutBuilder lets the sliver's layout changes be fed back out to
      // its owner to trigger state changes.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          latestIndicatorBoxExtent = constraints.maxHeight;
          if (widget.builder != null && latestIndicatorBoxExtent > 0) {
            return widget.builder!(
              context,
              latestIndicatorBoxExtent,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _SliverOverscroll extends SingleChildRenderObjectWidget {
  const _SliverOverscroll({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  _RenderSliverOverscroll createRenderObject(BuildContext context) {
    return _RenderSliverOverscroll();
  }
}

// RenderSliver object that gives its child RenderBox object space to paint
// in the overscrolled gap.
class _RenderSliverOverscroll extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderSliverOverscroll({
    RenderBox? child,
  }) {
    this.child = child;
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;

    final bool active = constraints.overlap < 0.0 || 0 > 0.0;
    final double overscrolledExtent =
        constraints.overlap < 0.0 ? constraints.overlap.abs() : 0.0;
    // Layout the child giving it the space of the currently dragged overscroll
    // which may or may not include a sliver layout extent space that it will
    // keep after the user lets go during the refresh process.
    child!.layout(
      constraints.asBoxConstraints(
        maxExtent: overscrolledExtent,
      ),
      parentUsesSize: true,
    );
    if (active) {
      geometry = SliverGeometry(
        paintOrigin: -overscrolledExtent - constraints.scrollOffset,
        paintExtent: max(
          // Check child size (which can come from overscroll) because
          // layoutExtent may be zero. Check layoutExtent also since even
          // with a layoutExtent, the indicator builder may decide to not
          // build anything.
          child!.size.height - constraints.scrollOffset,
          0.0,
        ),
        maxPaintExtent: max(
          child!.size.height - constraints.scrollOffset,
          0.0,
        ),
        layoutExtent: max(-constraints.scrollOffset, 0.0),
      );
    } else {
      // If we never started overscrolling, return no geometry.
      geometry = SliverGeometry.zero;
    }
  }

  @override
  void paint(PaintingContext paintContext, Offset offset) {
    if (constraints.overlap < 0.0 ||
        constraints.scrollOffset + child!.size.height > 0) {
      paintContext.paintChild(child!, offset);
    }
  }

  // Nothing special done here because this sliver always paints its child
  // exactly between paintOrigin and paintExtent.
  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}
}
