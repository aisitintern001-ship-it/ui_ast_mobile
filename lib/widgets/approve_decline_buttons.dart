import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable approve/decline buttons widget for admin approval workflows.
/// Can be used for leave requests, expense claims, and other approval flows.
class ApproveDeclineButtons extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;
  final String approveLabel;
  final String declineLabel;
  final bool showIcons;
  final bool expanded;
  final double height;
  final double spacing;
  final Color approveColor;
  final Color declineColor;

  const ApproveDeclineButtons({
    super.key,
    this.onApprove,
    this.onDecline,
    this.approveLabel = "Approve All",
    this.declineLabel = "Deny All",
    this.showIcons = true,
    this.expanded = true,
    this.height = 40,
    this.spacing = 12,
    this.approveColor = Colors.teal,
    this.declineColor = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return Row(
        children: [
          Expanded(child: _buildApproveButton()),
          SizedBox(width: spacing),
          Expanded(child: _buildDeclineButton()),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildApproveButton(),
        SizedBox(width: spacing),
        _buildDeclineButton(),
      ],
    );
  }

  Widget _buildApproveButton() {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: approveColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: approveColor,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onApprove ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (showIcons) ...[
              const Icon(Icons.check, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              approveLabel,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeclineButton() {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: declineColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: declineColor,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onDecline ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (showIcons) ...[
              const Icon(Icons.close, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              declineLabel,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual circular approve/decline action buttons for per-item actions.
/// Used in expandable sections where each day/item can be approved individually.
class ApproveDeclineIconButtons extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;
  final double size;
  final Color approveColor;
  final Color declineColor;

  const ApproveDeclineIconButtons({
    super.key,
    this.onApprove,
    this.onDecline,
    this.size = 28,
    this.approveColor = Colors.teal,
    this.declineColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onApprove,
          child: Container(
            padding: EdgeInsets.all(size * 0.15),
            decoration: BoxDecoration(
              color: approveColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: size * 0.5,
              color: approveColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onDecline,
          child: Container(
            padding: EdgeInsets.all(size * 0.15),
            decoration: BoxDecoration(
              color: declineColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close,
              size: size * 0.5,
              color: declineColor,
            ),
          ),
        ),
      ],
    );
  }
}
