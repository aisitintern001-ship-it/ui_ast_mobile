import 'package:flutter/material.dart';

/// Animated grid that shows items with a staggered animation
class AnimatedGrid extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final Duration itemDuration;
  final Duration staggerDelay;
  final EdgeInsets padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const AnimatedGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.childAspectRatio = 1,
    this.itemDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<AnimatedGrid> createState() => _AnimatedGridState();
}

class _AnimatedGridState extends State<AnimatedGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return _AnimatedGridItem(
          index: index,
          duration: widget.itemDuration,
          delay: widget.staggerDelay * index,
          child: widget.itemBuilder(context, index),
        );
      },
    );
  }
}

class _AnimatedGridItem extends StatefulWidget {
  final int index;
  final Duration duration;
  final Duration delay;
  final Widget child;

  const _AnimatedGridItem({
    required this.index,
    required this.duration,
    required this.delay,
    required this.child,
  });

  @override
  State<_AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<_AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Animated horizontal scrolling list
class AnimatedHorizontalList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double height;
  final Duration itemDuration;
  final Duration staggerDelay;
  final EdgeInsets padding;
  final double itemWidth;
  final double spacing;

  const AnimatedHorizontalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 120,
    this.itemDuration = const Duration(milliseconds: 400),
    this.staggerDelay = const Duration(milliseconds: 80),
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.itemWidth = 100,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          return _AnimatedHorizontalItem(
            index: index,
            duration: itemDuration,
            delay: staggerDelay * index,
            width: itemWidth,
            child: itemBuilder(context, index),
          );
        },
      ),
    );
  }
}

class _AnimatedHorizontalItem extends StatefulWidget {
  final int index;
  final Duration duration;
  final Duration delay;
  final double width;
  final Widget child;

  const _AnimatedHorizontalItem({
    required this.index,
    required this.duration,
    required this.delay,
    required this.width,
    required this.child,
  });

  @override
  State<_AnimatedHorizontalItem> createState() => _AnimatedHorizontalItemState();
}

class _AnimatedHorizontalItemState extends State<_AnimatedHorizontalItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SizedBox(
          width: widget.width,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Animated reorderable grid with drag and drop
class AnimatedReorderableList extends StatefulWidget {
  final List<Widget> children;
  final Duration animationDuration;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final Axis direction;
  final EdgeInsets padding;

  const AnimatedReorderableList({
    super.key,
    required this.children,
    this.animationDuration = const Duration(milliseconds: 300),
    this.onReorder,
    this.direction = Axis.vertical,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<AnimatedReorderableList> createState() => _AnimatedReorderableListState();
}

class _AnimatedReorderableListState extends State<AnimatedReorderableList> {
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = List.from(widget.children);
  }

  @override
  void didUpdateWidget(AnimatedReorderableList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != _children.length) {
      _children = List.from(widget.children);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      padding: widget.padding,
      scrollDirection: widget.direction,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final animValue = Curves.easeInOut.transform(animation.value);
            final elevation = 4.0 * animValue;
            final scale = 1.0 + (0.05 * animValue);

            return Transform.scale(
              scale: scale,
              child: Material(
                elevation: elevation,
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _children.removeAt(oldIndex);
          _children.insert(newIndex, item);
        });
        widget.onReorder?.call(oldIndex, newIndex);
      },
      children: [
        for (int i = 0; i < _children.length; i++)
          Container(
            key: ValueKey(i),
            child: _children[i],
          ),
      ],
    );
  }
}

/// Animated wrap widget that staggers children
class AnimatedWrap extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration staggerDelay;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;

  const AnimatedWrap({
    super.key,
    required this.children,
    this.itemDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 40),
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (int i = 0; i < children.length; i++)
          _AnimatedWrapItem(
            index: i,
            duration: itemDuration,
            delay: staggerDelay * i,
            child: children[i],
          ),
      ],
    );
  }
}

class _AnimatedWrapItem extends StatefulWidget {
  final int index;
  final Duration duration;
  final Duration delay;
  final Widget child;

  const _AnimatedWrapItem({
    required this.index,
    required this.duration,
    required this.delay,
    required this.child,
  });

  @override
  State<_AnimatedWrapItem> createState() => _AnimatedWrapItemState();
}

class _AnimatedWrapItemState extends State<_AnimatedWrapItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
