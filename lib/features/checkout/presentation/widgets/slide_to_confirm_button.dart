import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class SlideToConfirmButton extends StatefulWidget {
  const SlideToConfirmButton({
    required this.label,
    required this.onConfirm,
    this.isLoading = false,
    this.enabled = true,
    super.key,
  });

  final String label;
  final VoidCallback onConfirm;
  final bool isLoading;
  final bool enabled;

  @override
  State<SlideToConfirmButton> createState() => _SlideToConfirmButtonState();
}

class _SlideToConfirmButtonState extends State<SlideToConfirmButton>
    with SingleTickerProviderStateMixin {
  static const _thumbSize = 48.0;
  static const _trackHeight = 56.0;
  static const _trackInset = 4.0;
  static const _confirmThreshold = 0.85;

  late final AnimationController _controller;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
  }

  @override
  void didUpdateWidget(covariant SlideToConfirmButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading) {
      _confirmed = false;
      _controller.animateTo(0, curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _interactive => widget.enabled && !widget.isLoading && !_confirmed;

  void _onDragUpdate(DragUpdateDetails details, double maxOffset, bool isRtl) {
    if (!_interactive || maxOffset <= 0) return;
    final forwardDelta = isRtl ? -details.delta.dx : details.delta.dx;
    final current = _controller.value * maxOffset;
    setState(() => _controller.value = ((current + forwardDelta) / maxOffset).clamp(0.0, 1.0));
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_interactive) return;
    if (_controller.value >= _confirmThreshold) {
      setState(() => _confirmed = true);
      _controller.animateTo(1, curve: Curves.easeOut);
      widget.onConfirm();
    } else {
      _controller.animateTo(0, curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final trackColor = widget.enabled ? scheme.primary : scheme.surfaceContainerHighest;
    final labelColor = widget.enabled ? scheme.onPrimary : scheme.onSurfaceVariant;
    final thumbIconColor = widget.enabled ? scheme.primary : scheme.onSurfaceVariant;

    return Container(
      height: _trackHeight,
      padding: const EdgeInsets.all(_trackInset),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxOffset = (constraints.maxWidth - _thumbSize).clamp(0.0, double.infinity);
          return GestureDetector(
            onHorizontalDragUpdate: (details) => _onDragUpdate(details, maxOffset, isRtl),
            onHorizontalDragEnd: _onDragEnd,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = _controller.value * maxOffset;
                final thumbLeft = isRtl ? (maxOffset - offset) : offset;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: (1 - _controller.value * 2).clamp(0.0, 1.0),
                      child: Text(
                        widget.label,
                        style: TextStyle(color: labelColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Positioned(
                      left: thumbLeft,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: _thumbSize,
                        height: _thumbSize,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Center(
                          child: widget.isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: thumbIconColor,
                                  ),
                                )
                              : Icon(
                                  isRtl
                                      ? Icons.keyboard_arrow_left_rounded
                                      : Icons.keyboard_arrow_right_rounded,
                                  color: thumbIconColor,
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
