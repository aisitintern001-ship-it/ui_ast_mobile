import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A button with ripple effect and haptic feedback
class TapBounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration duration;
  final double pressScale;
  final bool enableHaptic;
  final BorderRadius? borderRadius;

  const TapBounceButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.duration = const Duration(milliseconds: 100),
    this.pressScale = 0.95,
    this.enableHaptic = true,
    this.borderRadius,
  });

  @override
  State<TapBounceButton> createState() => _TapBounceButtonState();
}

class _TapBounceButtonState extends State<TapBounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Animated counter that smoothly transitions between numbers
class AnimatedCounter extends StatelessWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 500),
    this.style,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '${prefix ?? ''}$value${suffix ?? ''}',
          style: style,
        );
      },
    );
  }
}

/// Animated progress bar
class AnimatedProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final Duration duration;
  final BorderRadius? borderRadius;

  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor = const Color(0xFFE5E7EB),
    this.progressColor = const Color(0xFF2181FF),
    this.duration = const Duration(milliseconds: 300),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(height / 2);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                height: height,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: radius,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Animated gradient progress bar
class AnimatedGradientProgressBar extends StatefulWidget {
  final double value;
  final double height;
  final Color backgroundColor;
  final List<Color> gradientColors;
  final Duration duration;
  final BorderRadius? borderRadius;

  const AnimatedGradientProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor = const Color(0xFFE5E7EB),
    this.gradientColors = const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    this.duration = const Duration(milliseconds: 300),
    this.borderRadius,
  });

  @override
  State<AnimatedGradientProgressBar> createState() =>
      _AnimatedGradientProgressBarState();
}

class _AnimatedGradientProgressBarState
    extends State<AnimatedGradientProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(widget.height / 2);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: radius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: widget.duration,
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * widget.value.clamp(0.0, 1.0),
                height: widget.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.gradientColors),
                  borderRadius: radius,
                ),
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.3),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          stops: [
                            (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                            _shimmerController.value,
                            (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: radius,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Animated badge counter
class AnimatedBadge extends StatelessWidget {
  final int count;
  final Color backgroundColor;
  final Color textColor;
  final double size;
  final Duration duration;

  const AnimatedBadge({
    super.key,
    required this.count,
    this.backgroundColor = const Color(0xFFEF4444),
    this.textColor = Colors.white,
    this.size = 20,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: count > 0
          ? Container(
              key: ValueKey(count),
              constraints: BoxConstraints(
                minWidth: size,
                minHeight: size,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(size / 2),
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

/// Animated icon with morph transition
class AnimatedIconMorph extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;
  final Duration duration;

  const AnimatedIconMorph({
    super.key,
    required this.icon,
    this.color,
    this.size = 24,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.5, end: 0.0).animate(animation),
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: Icon(
        icon,
        key: ValueKey(icon),
        color: color,
        size: size,
      ),
    );
  }
}

/// Animated color change for any widget
class AnimatedColorChange extends StatelessWidget {
  final Color color;
  final Duration duration;
  final Widget Function(Color) builder;

  const AnimatedColorChange({
    super.key,
    required this.color,
    this.duration = const Duration(milliseconds: 300),
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: color),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, color, child) {
        return builder(color ?? this.color);
      },
    );
  }
}

/// Animated visibility with fade and slide
class AnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Duration duration;
  final Offset slideOffset;

  const AnimatedVisibility({
    super.key,
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.slideOffset = const Offset(0, -0.1),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: slideOffset,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: visible
          ? SizedBox(
              key: const ValueKey('visible'),
              child: child,
            )
          : const SizedBox.shrink(
              key: ValueKey('hidden'),
            ),
    );
  }
}

/// Floating action button with entry animation
class AnimatedFloatingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double size;
  final Duration entryDuration;
  final Duration entryDelay;

  const AnimatedFloatingButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.size = 56,
    this.entryDuration = const Duration(milliseconds: 400),
    this.entryDelay = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedFloatingButton> createState() => _AnimatedFloatingButtonState();
}

class _AnimatedFloatingButtonState extends State<AnimatedFloatingButton>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: widget.entryDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.elasticOut),
    );

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _pressAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    Future.delayed(widget.entryDelay, () {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(
          scale: _pressAnimation,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.backgroundColor ?? Theme.of(context).primaryColor)
                      .withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

/// Animated typing text effect
class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration typingSpeed;
  final VoidCallback? onComplete;

  const TypingText({
    super.key,
    required this.text,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 50),
    this.onComplete,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayedText = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    while (_currentIndex < widget.text.length && mounted) {
      await Future.delayed(widget.typingSpeed);
      if (mounted) {
        setState(() {
          _currentIndex++;
          _displayedText = widget.text.substring(0, _currentIndex);
        });
      }
    }
    if (mounted) {
      widget.onComplete?.call();
    }
  }

  @override
  void didUpdateWidget(TypingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _currentIndex = 0;
      _displayedText = '';
      _startTyping();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}
