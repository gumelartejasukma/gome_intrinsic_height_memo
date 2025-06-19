import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class IntrinsicHeightMemo extends StatefulWidget {
  final Widget child;
  // final Curve curve;
  final Object? resetKey;
  final void Function(double newHeight)? onChangeHeight;
  final void Function(
    bool Function(ScrollNotification) onScroll,
    VoidCallbackAction callback,
  )?
  onScroll;
  final int? index;

  const IntrinsicHeightMemo({
    super.key,
    required this.child,
    this.resetKey,
    this.onChangeHeight,
    this.onScroll,
    this.index,
  });

  @override
  State<IntrinsicHeightMemo> createState() => _IntrinsicHeightMemoState();
}

class _IntrinsicHeightMemoState extends State<IntrinsicHeightMemo> {
  double? _cachedHeight;
  final GlobalKey _measureKey = GlobalKey();
  Object? _prevResetKey;
  RenderBox? box;
  bool isVisible = true;
  Timer? throttleTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeight());
  }

  @override
  void didUpdateWidget(covariant IntrinsicHeightMemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetKey != _prevResetKey) {
      _cachedHeight = null;
      _prevResetKey = widget.resetKey;
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeight());
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _measureHeight(autoUpdate: true),
      );
    }
  }

  void _measureHeight({bool autoUpdate = false}) async {
    final context = _measureKey.currentContext;
    if (context == null) return;
    if (_cachedHeight != null) return;

    final random = Random();
    final milliseconds = widget.index ?? random.nextInt(300);
    if (!mounted) return;
    if (throttleTimer?.isActive ?? false) return;
    throttleTimer = Timer(Duration(milliseconds: milliseconds), () {
      final size = context.size;
      if (size != null) {
        // box = _box;
        // final newHeight = box!.size.height;
        final newHeight = size.height;
        final prev = _cachedHeight ?? 0;

        // Auto update only if change is > 10%
        if (!autoUpdate ||
            (prev - newHeight).abs() / (prev == 0 ? 1 : prev) > 0.1) {
          setState(() {
            _cachedHeight = newHeight;
          });
          if (widget.onChangeHeight != null) {
            widget.onChangeHeight!(newHeight);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _measureKey,
      height: _cachedHeight,
      child: widget.child,
    );
  }
}
