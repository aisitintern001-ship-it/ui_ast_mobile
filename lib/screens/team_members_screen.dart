import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/text_input.dart';
import '../widgets/bottom_nav.dart';

class _MemberData {
  final String name;
  final String initials;
  final Color avatarColor;
  final String position;
  final String department;
  final String status; // 'Active', 'On Leave'
  final String email;
  final String phone;
  final String dateHired;
  final String location;

  const _MemberData({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.position,
    required this.department,
    required this.status,
    required this.email,
    required this.phone,
    required this.dateHired,
    required this.location,
  });
}

final List<_MemberData> _mockMembers = [
  _MemberData(
    name: 'Edward Peter',
    initials: 'EP',
    avatarColor: const Color(0xFF2563EB),
    position: 'Senior Software Engineer',
    department: 'IT Development',
    status: 'Active',
    email: 'epeter@ast.com.ph',
    phone: '+63 917 12 4567',
    dateHired: 'Mar 15, 2021',
    location: 'Makati City, Philippines',
  ),
  _MemberData(
    name: 'Daniel Gray',
    initials: 'DG',
    avatarColor: const Color(0xFF7C3AED),
    position: 'Software Engineer',
    department: 'IT Development',
    status: 'Active',
    email: 'dgray@ast.com.ph',
    phone: '+63 917 12 4567',
    dateHired: 'Mar 15, 2021',
    location: 'Makati City, Philippines',
  ),
  _MemberData(
    name: 'Amanda Roberts',
    initials: 'AR',
    avatarColor: const Color(0xFFEC4899),
    position: 'Junior Developer',
    department: 'IT Development',
    status: 'On Leave',
    email: 'aroberts@ast.com.ph',
    phone: '+63 917 12 4567',
    dateHired: 'Jul 12, 2022',
    location: 'Makati City, Philippines',
  ),
  _MemberData(
    name: 'Maria Dela Rosa',
    initials: 'MR',
    avatarColor: const Color(0xFF10B981),
    position: 'UI/UX Designer',
    department: 'Design',
    status: 'Active',
    email: 'mdelarosa@ast.com.ph',
    phone: '+63 917 12 4567',
    dateHired: 'Feb 01, 2023',
    location: 'Makati City, Philippines',
  ),
  _MemberData(
    name: 'Michael Chen',
    initials: 'MC',
    avatarColor: const Color(0xFFF59E0B),
    position: 'Operations Manager',
    department: 'Operations',
    status: 'Active',
    email: 'mchen@ast.com.ph',
    phone: '+63 917 12 4567',
    dateHired: 'Jan 10, 2020',
    location: 'Makati City, Philippines',
  ),
  _MemberData(
    name: 'Anika Carder',
    initials: 'AC',
    avatarColor: const Color(0xFFEF4444),
    position: 'Operations Coordinator',
    department: 'Operations',
    status: 'On Leave',
    email: 'acarder@ast.com.ph',
    phone: '+63 917 12 4567',
    dateHired: 'Oct 05, 2021',
    location: 'Makati City, Philippines',
  ),
  _MemberData(
    name: 'John Rivera',
    initials: 'JR',
    avatarColor: const Color(0xFF0D9488),
    position: 'QA Analyst',
    department: 'Quality Assurance',
    status: 'Active',
    email: 'jrivera@ast.com.ph',
    phone: '+63 917 12 4567',
    dateHired: 'Apr 21, 2022',
    location: 'Makati City, Philippines',
  ),
];

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;
  String _selectedDepartment = 'All';
  String _selectedTeam = 'All';
  String _selectedReporting = 'All';
  int? _expandedIndex;
  bool get _hasActiveFilters =>
      _selectedDepartment != 'All' ||
      _selectedTeam != 'All' ||
      _selectedReporting != 'All';

  List<_MemberData> get _filteredMembers {
    var members = _mockMembers;
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      members = members
          .where(
            (m) =>
                m.name.toLowerCase().contains(query) ||
                m.position.toLowerCase().contains(query),
          )
          .toList();
    }
    if (_selectedDepartment != 'All') {
      members = members
          .where((m) => m.department == _selectedDepartment)
          .toList();
    }
    return members;
  }

  Map<String, List<_MemberData>> get _groupedMembers {
    final map = <String, List<_MemberData>>{};
    for (final m in _filteredMembers) {
      map.putIfAbsent(m.department, () => []).add(m);
    }
    return map;
  }

  int get _totalCount => _filteredMembers.length;
  int get _activeCount =>
      _filteredMembers.where((m) => m.status == 'Active').length;
  int get _onLeaveCount =>
      _filteredMembers.where((m) => m.status == 'On Leave').length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = context.watch<AppState>().headerColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: headerColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Team Members',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Stats row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _StatPill(
                  label: 'Total',
                  value: _totalCount.toString(),
                  color: AppColors.headerOrange,
                ),
                const SizedBox(width: 8),
                _StatPill(
                  label: 'Active',
                  value: _activeCount.toString(),
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                _StatPill(
                  label: 'On Leave',
                  value: _onLeaveCount.toString(),
                  color: AppColors.dangerRed,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          // Search bar + filter toggle
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: AppTextInput(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.inter(fontSize: 13),
                      hintText: 'Search member...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _showFilters = !_showFilters),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _showFilters
                          ? AppColors.headerOrange
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.slidersHorizontal,
                      size: 18,
                      color: _showFilters
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter section
          if (_showFilters)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Column(
                children: [
                  _FilterDropdown(
                    label: 'Department',
                    icon: Icons.apartment_outlined,
                    value: _selectedDepartment,
                    items: const [
                      'All',
                      'IT Development',
                      'Design',
                      'Operations',
                      'Quality Assurance',
                      'Customer Support',
                      'Project Management',
                    ],
                    onChanged: (v) =>
                        setState(() => _selectedDepartment = v ?? 'All'),
                  ),
                  const SizedBox(height: 8),
                  _FilterDropdown(
                    label: 'Team',
                    icon: Icons.groups_2_outlined,
                    value: _selectedTeam,
                    items: const ['All', 'Team Alpha', 'Team Beta'],
                    onChanged: (v) =>
                        setState(() => _selectedTeam = v ?? 'All'),
                  ),
                  const SizedBox(height: 8),
                  _FilterDropdown(
                    label: 'Reporting To',
                    icon: Icons.person_outline,
                    value: _selectedReporting,
                    items: const ['All', 'Edward Peter', 'Michael Chen'],
                    onChanged: (v) =>
                        setState(() => _selectedReporting = v ?? 'All'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: _hasActiveFilters ? () => setState(() {}) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2181FF),
                        disabledBackgroundColor: const Color(0xFFDCE7F5),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: const Color(0xFFB7C5D8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Apply Filter'),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1, color: AppColors.divider),
          // Members list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _buildGroupedList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  List<Widget> _buildGroupedList() {
    final groups = _groupedMembers;
    final widgets = <Widget>[];
    int globalIndex = 0;

    for (final entry in groups.entries) {
      // Department header
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: widgets.isEmpty ? 0 : 16, bottom: 8),
          child: Row(
            children: [
              Text(
                entry.key,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  entry.value.length.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      for (final member in entry.value) {
        final idx = globalIndex;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _MemberCard(
              member: member,
              isExpanded: _expandedIndex == idx,
              onToggle: () {
                setState(() {
                  _expandedIndex = _expandedIndex == idx ? null : idx;
                });
              },
            ),
          ),
        );
        globalIndex++;
      }
    }
    return widgets;
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _FilterField(
      icon: icon,
      label: label,
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}

class _FilterField extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterField({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<_FilterField> createState() => _FilterFieldState();
}

class _FilterFieldState extends State<_FilterField> {
  Future<void> _openMenu() async {
    final box = context.findRenderObject() as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero);
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        topLeft.dx,
        topLeft.dy + box.size.height + 4,
        topLeft.dx + box.size.width - 220,
        topLeft.dy,
      ),
      items: [
        for (final item in widget.items.where((e) => e != 'All'))
          PopupMenuItem<String>(
            value: item,
            height: 40,
            child: Row(
              children: [
                Icon(
                  widget.value == item
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 16,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(width: 10),
                Text(
                  item,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    if (selected != null) widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = widget.value != 'All';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasSelection) ...[
          Wrap(
            spacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, size: 13, color: const Color(0xFF6B7280)),
                    const SizedBox(width: 6),
                    Text(
                      widget.value,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => widget.onChanged('All'),
                      child: const Icon(Icons.close, size: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: _openMenu,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(widget.icon, size: 18, color: const Color(0xFF9CA3AF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MemberCard extends StatelessWidget {
  final _MemberData member;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _MemberCard({
    required this.member,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final safeName = _safeText(member.name);
    final safePosition = _safeText(member.position);
    final safeDepartment = _safeText(member.department);
    final safeStatus = _safeText(member.status, fallback: 'Active');
    final safeEmail = _safeText(member.email);
    final safePhone = _safeText(member.phone);
    final safeDateHired = _safeText(member.dateHired);
    final safeLocation = _safeText(member.location);
    final isActive = safeStatus == 'Active';
    final statusColor = isActive
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);
    final statusBg = isActive
        ? const Color(0xFF10B981).withValues(alpha: 0.1)
        : const Color(0xFFF59E0B).withValues(alpha: 0.1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: member.avatarColor.withValues(
                          alpha: 0.15,
                        ),
                               child: Text(
                            _safeText(member.initials, fallback: '--'),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: member.avatarColor,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: const Color(0xFF14B8A6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                               child: Text(
                                safeName,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(25),
                              ),
                               child: Text(
                                safeStatus,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          safePosition,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          safeDepartment,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          // Expanded details
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTACT INFORMATION',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _infoTile(
                          icon: Icons.mail_outline,
                          title: 'Email',
                          value: safeEmail,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _infoTile(
                          icon: Icons.call_outlined,
                          title: 'Phone',
                          value: safePhone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'WORK INFORMATION',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _infoTile(
                          icon: Icons.work_outline,
                          title: 'Job Title',
                          value: safePosition,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _infoTile(
                          icon: Icons.event_outlined,
                          title: 'Date Hired',
                          value: safeDateHired,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 52) / 2,
                    child: _infoTile(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      value: safeLocation,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFFDEDE8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 14, color: const Color(0xFFEF532A)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _safeText(String? value, {String fallback = '-'}) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return fallback;
    return text;
  }
}
