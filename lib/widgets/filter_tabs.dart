import 'package:flutter/material.dart';

class FilterTabs extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const FilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FilterTab(
          label: "Last 7 Days",
          value: "7",
          isSelected: selected == "7",
          onTap: () => onChanged("7"),
        ),
        const SizedBox(width: 8),
        _FilterTab(
          label: "Last 30 Days",
          value: "30",
          isSelected: selected == "30",
          onTap: () => onChanged("30"),
        ),
        const SizedBox(width: 8),
        _FilterTab(
          label: "Custom",
          value: "custom",
          isSelected: selected == "custom",
          onTap: () => onChanged("custom"),
        ),
      ],
    );
  }
}

class _FilterTab extends StatefulWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterTab> createState() => _FilterTabState();
}

class _FilterTabState extends State<_FilterTab>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            constraints: const BoxConstraints(minHeight: 36),
            decoration: BoxDecoration(
              color: widget.isSelected ? const Color(0xFF2181FF) : Colors.white,
              border: widget.isSelected ? null : Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2181FF).withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}