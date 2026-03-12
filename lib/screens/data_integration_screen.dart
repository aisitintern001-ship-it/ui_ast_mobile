import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/bottom_nav.dart';
import '../screens/attendance_screen.dart';
import '../screens/personal_leave_screen.dart';

class DataIntegrationScreen extends StatelessWidget {
  const DataIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch AppState to get the dynamic company header color
    final headerColor = context.watch<AppState>().headerColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: headerColor, // Matches selected company color
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Data Integration',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Product Integration
            _buildIntegrationCard(
              icon: Icons.inventory_2_outlined,
              iconColor: headerColor, // Matches company color
              brandColor: headerColor,
              title: 'Product Integration',
              subtitle: 'Product Sync\nLast sync: 3 hours ago',
              actionIcon: Icons.sync_rounded,
            ),
            const SizedBox(height: 12),

            // 2. Product Image
            _buildIntegrationCard(
              icon: Icons.image_outlined,
              iconColor: headerColor,
              brandColor: headerColor,
              title: 'Product Image',
              subtitle: '0 base images out of 0',
              actionIcon: Icons.file_download_outlined,
              showProgressBar: true, 
            ),
            const SizedBox(height: 12),

            // 3. Attendance Records (Clickable)
            _buildIntegrationCard(
              icon: Icons.assignment_outlined,
              iconColor: const Color(0xFF10B981), // Green
              brandColor: headerColor,
              title: 'Attendance Records',
              subtitle: 'Sync offline attendance',
              actionIcon: Icons.sync_rounded,
              pendingCount: '5 Pending',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AttendanceScreen(
                      initialShowHistory: false,
                      fromDataIntegration: true, // 👈 Added this flag
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // 4. Leave Records (Clickable)
            _buildIntegrationCard(
              icon: Icons.access_time_rounded,
              iconColor: const Color(0xFF8B5CF6), // Purple
              brandColor: headerColor,
              title: 'Leave Records',
              subtitle: 'Sync offline leave records request',
              actionIcon: Icons.sync_rounded,
              pendingCount: '5 Pending',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalLeaveScreen(
                      initialTab: 1,
                      fromDataIntegration: true, // 👈 Added this flag
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Info text at the bottom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All data is synced on the server.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  // Reusable widget that accepts onTap and dynamic brand colors
  Widget _buildIntegrationCard({
    required IconData icon,
    required Color iconColor,
    required Color brandColor,
    required String title,
    required String subtitle,
    required IconData actionIcon,
    String? pendingCount,
    bool showProgressBar = false,
    VoidCallback? onTap, // Accepts click actions
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Ensures the whole card is clickable even on empty spaces
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  
                  // Texts (Title & Subtitle)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Trailing actions (Badge + Button)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (pendingCount != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED), 
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pendingCount,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFD97706), 
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      
                      // Action Icon Button (Sync or Download)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: brandColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(actionIcon, color: brandColor, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Optional bottom progress bar 
            if (showProgressBar)
              Container(
                height: 4,
                width: double.infinity,
                color: brandColor,
              ),
          ],
        ),
      ),
    );
  }
}