import 'package:flutter/material.dart';

/// An animated card with press feedback and optional entrance animation
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? splashColor;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Duration animationDuration;
  final double pressScale;
  final bool enableEntryAnimation;
  final Duration entryDelay;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.splashColor,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.border,
    this.boxShadow,
    this.animationDuration = const Duration(milliseconds: 150),
    this.pressScale = 0.98,
    this.enableEntryAnimation = false,
    this.entryDelay = Duration.zero,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _entryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _entryAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Press animation
    _pressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOutCubic,
    ));

    // Entry animation
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _entryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.enableEntryAnimation) {
      if (widget.entryDelay == Duration.zero) {
        _entryController.forward();
      } else {
        Future.delayed(widget.entryDelay, () {
          if (mounted) _entryController.forward();
        });
      }
    } else {
      _entryController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget card = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: widget.border,
          boxShadow: widget.boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: InkWell(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            splashColor: widget.splashColor ?? Colors.black.withValues(alpha: 0.05),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.onTap != null || widget.onLongPress != null) {
      card = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: card,
      );
    }

    if (widget.enableEntryAnimation) {
      return FadeTransition(
        opacity: _entryAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: card,
        ),
      );
    }

    return card;
  }
}

/// A list tile with smooth press animation
class AnimatedListTile extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets contentPadding;
  final double pressScale;
  final Duration animationDuration;
  final Color? backgroundColor;
  final Color? splashColor;
  final double borderRadius;

  const AnimatedListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.pressScale = 0.98,
    this.animationDuration = const Duration(milliseconds: 100),
    this.backgroundColor,
    this.splashColor,
    this.borderRadius = 8,
  });

  @override
  State<AnimatedListTile> createState() => _AnimatedListTileState();
}

class _AnimatedListTileState extends State<AnimatedListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
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
      onTapDown: widget.onTap != null ? _onTapDown : null,
      onTapUp: widget.onTap != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null ? _onTapCancel : null,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: widget.contentPadding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.title != null) widget.title!,
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 4),
                      widget.subtitle!,
                    ],
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 12),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated FAB button with scale effect
class AnimatedFab extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double size;
  final double pressScale;
  final List<BoxShadow>? boxShadow;

  const AnimatedFab({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.size = 56,
    this.pressScale = 0.92,
    this.boxShadow,
  });

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
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
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            boxShadow: widget.boxShadow ??
                [
                  BoxShadow(
                    color: (widget.backgroundColor ?? Theme.of(context).primaryColor)
                        .withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

/// Animated expandable container
class AnimatedExpandable extends StatefulWidget {
  final Widget header;
  final Widget child;
  final bool initiallyExpanded;
  final Duration duration;
  final ValueChanged<bool>? onExpansionChanged;

  const AnimatedExpandable({
    super.key,
    required this.header,
    required this.child,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 300),
    this.onExpansionChanged,
  });

  @override
  State<AnimatedExpandable> createState() => _AnimatedExpandableState();
}

class _AnimatedExpandableState extends State<AnimatedExpandable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleExpanded,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Expanded(child: widget.header),
              RotationTransition(
                turns: _rotateAnimation,
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: widget.child,
        ),
      ],
    );
  }
}
