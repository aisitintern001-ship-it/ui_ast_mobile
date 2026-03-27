import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Import your state and models
import '../models/app_state.dart';
import '../widgets/bottom_nav.dart';
import 'profile_info_screen.dart';

// Import your reusable modals
import '../modals/shift_schedule_modal.dart';
import '../modals/data_retention_modal.dart';
import '../modals/available_leave_modal.dart';
import '../widgets/favorites_section.dart';
import '../screens/data_integration_screen.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for the Offline Records Policy dropdown
  bool _isPolicyExpanded = false;
  String _selectedPolicy = "Delete after 1 month";

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back arrow for a clean tab look
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE SECTION: Navigates to ProfileInfoScreen
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileInfoScreen()),
                );
              },
              child: _buildProfileCard(user),
            ),
            const SizedBox(height: 24),

            // APP SECTION
            _buildSectionHeader('APP'),
            _buildSettingsCard(
              children: [
                GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () => _showModal(const FavoritesManagementSheet()),
  child: _buildSettingsTile(
    icon: LucideIcons.layoutGrid,
    iconColor: const Color(0xFF14B8A6),
    title: 'Edit Categories',
  ),
),

_buildDivider(),
                GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DataIntegrationScreen(),
      ),
    );
  },
  child: _buildSettingsTile(
    icon: LucideIcons.databaseBackup,
    iconColor: const Color(0xFFF97316),
    title: 'Data Integration',
  ),
),
                _buildDivider(),
                // View Entitlement Trigger: Opens AvailableLeaveModal
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showModal(const AvailableLeaveModal()),
                  child: _buildSettingsTile(
                    icon: LucideIcons.treePalm,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'View Entitlement',
                  ),
                ),
                _buildDivider(),
                // View Shift Schedule Trigger
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showModal(const ShiftScheduleModal()),
                  child: _buildSettingsTile(
                    icon: LucideIcons.calendar,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'View Shift Schedule',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // DATA RETENTION SECTION: Includes Info Modal Trigger
            Row(
              children: [
                _buildSectionHeader('DATA RETENTION SETTINGS', bottomPadding: 0),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _showModal(const DataRetentionModal()),
                  child: const Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildSettingsCard(
              children: [
                // Expandable Policy Tile
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _isPolicyExpanded = !_isPolicyExpanded),
                  child: _buildSettingsTile(
                    icon: LucideIcons.wifiOff,
                    iconColor: const Color(0xFF6B7280),
                    title: 'Offline Records Policy',
                    trailingIcon: _isPolicyExpanded 
                        ? Icons.keyboard_arrow_up_rounded 
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                ),
                if (_isPolicyExpanded) ...[
                  _buildPolicyOption("Delete after 1 month"),
                  _buildPolicyOption("Delete after 3 months"),
                  _buildPolicyOption("Never delete"),
                  const SizedBox(height: 8),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // GENERAL SECTION
            _buildSectionHeader('GENERAL'),
            _buildSettingsCard(
              children: [
                _buildSettingsTile(icon: Icons.language_rounded, iconColor: const Color(0xFF06B6D4), title: 'Website', showTrailing: false),
                _buildDivider(),
                _buildSettingsTile(icon: Icons.facebook_rounded, iconColor: const Color(0xFF3B5998), title: 'Facebook', showTrailing: false),
                _buildDivider(),
                _buildSettingsTile(icon: Icons.flutter_dash_rounded, iconColor: const Color(0xFF111827), title: 'Twitter', showTrailing: false),
                _buildDivider(),
                _buildSettingsTile(icon: Icons.lock_outline_rounded, iconColor: const Color(0xFFF43F5E), title: 'Privacy Policy', showTrailing: false),
                _buildDivider(),
                _buildSettingsTile(icon: Icons.verified_user_outlined, iconColor: const Color(0xFF0EA5E9), title: 'Terms of Use', showTrailing: false),
              ],
            ),
            const SizedBox(height: 24),

            // LOGOUT SECTION: Includes Confirmation Dialog
            _buildSettingsCard(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showLogoutConfirmation(context),
                  child: _buildSettingsTile(
                    icon: LucideIcons.logOut,
                    iconColor: const Color(0xFFF97316),
                    title: 'Logout',
                    showTrailing: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  // --- HELPER METHODS ---

  void _showModal(Widget modal) {
    showDialog(context: context, builder: (context) => modal);
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out of your account?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: const Text("Logout", style: TextStyle(color: Color(0xFFEF532A), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPolicyOption(String label) {
    bool isSelected = _selectedPolicy == label;
    return InkWell(
      onTap: () => setState(() => _selectedPolicy = label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 8),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFFEF532A) : Colors.grey.shade400,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isSelected ? Colors.black87 : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(dynamic user) {
    String initials = "U";
    String fullName = user.name ?? "Unknown User";
    if (fullName.isNotEmpty) {
      List<String> nameParts = fullName.trim().split(" ");
      initials = nameParts.length > 1 
          ? "${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}".toUpperCase()
          : nameParts[0][0].toUpperCase();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50, height: 50,
                decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 14, height: 14,
                  decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text("Senior Developer", style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {double bottomPadding = 8}) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: bottomPadding),
      child: Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 0.5)),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required Color iconColor, required String title, IconData trailingIcon = Icons.chevron_right_rounded, bool showTrailing = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87))),
          if (showTrailing) Icon(trailingIcon, color: Colors.grey.shade400, size: 22),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(padding: const EdgeInsets.only(left: 68), child: Divider(height: 1, thickness: 1, color: Colors.grey.shade100));
  }
}