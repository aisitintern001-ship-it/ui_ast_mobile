import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class NewsDetailModal extends StatelessWidget {
  final NewsItem news;

  const NewsDetailModal({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header image or fallback
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: news.imageUrl != null
                      ? Image.asset(
                          news.imageUrl!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => Container(
                            height: 160,
                            width: double.infinity,
                            color: AppColors.headerOrange,
                            child: const Icon(Icons.campaign_rounded, size: 48, color: Colors.white),
                          ),
                        )
                      : Container(
                          height: 160,
                          width: double.infinity,
                          color: AppColors.headerOrange,
                          child: const Icon(Icons.campaign_rounded, size: 48, color: Colors.white),
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(0xFFE9E6FD),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Event', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7C4DFF))),
                        ),
                        Text(news.date, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                        if (news.isImportant)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE3E3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('NEW', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFD32F2F))),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      news.title,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      news.content,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    if (news.attachments.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Attachments (${news.attachments.length})', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            const SizedBox(height: 8),
                            ...news.attachments.map((a) => _AttachmentTile(attachment: a)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Dismiss', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.headerOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Read More', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

// Attachment tile widget
          ],
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final NewsAttachment attachment;
  const _AttachmentTile({required this.attachment});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (attachment.type) {
      case 'pdf':
        icon = Icons.picture_as_pdf_rounded;
        color = Color(0xFFD32F2F);
        break;
      case 'image':
        icon = Icons.image_rounded;
        color = Color(0xFF1976D2);
        break;
      default:
        icon = Icons.attach_file_rounded;
        color = AppColors.textMuted;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              attachment.name,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
 
