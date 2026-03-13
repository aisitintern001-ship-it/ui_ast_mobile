import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  const _MemberData({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.position,
    required this.department,
    required this.status,
    required this.email,
    required this.phone,
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
    email: 'edward.peter@company.com',
    phone: '+63 912 345 6789',
  ),
  _MemberData(
    name: 'Daniel Gray',
    initials: 'DG',
    avatarColor: const Color(0xFF7C3AED),
    position: 'Software Engineer',
    department: 'IT Development',
    status: 'Active',
    email: 'daniel.gray@company.com',
    phone: '+63 912 345 6790',
  ),
  _MemberData(
    name: 'Amanda Roberts',
    initials: 'AR',
    avatarColor: const Color(0xFFEC4899),
    position: 'Junior Developer',
    department: 'IT Development',
    status: 'On Leave',
    email: 'amanda.roberts@company.com',
    phone: '+63 912 345 6791',
  ),
  _MemberData(
    name: 'Maria Dela Rosa',
    initials: 'MR',
    avatarColor: const Color(0xFF10B981),
    position: 'UI/UX Designer',
    department: 'Design',
    status: 'Active',
    email: 'maria.delarosa@company.com',
    phone: '+63 912 345 6792',
  ),
  _MemberData(
    name: 'Michael Chen',
    initials: 'MC',
    avatarColor: const Color(0xFFF59E0B),
    position: 'Operations Manager',
    department: 'Operations',
    status: 'Active',
    email: 'michael.chen@company.com',
    phone: '+63 912 345 6793',
  ),
  _MemberData(
    name: 'Anika Carder',
    initials: 'AC',
    avatarColor: const Color(0xFFEF4444),
    position: 'Operations Coordinator',
    department: 'Operations',
    status: 'On Leave',
    email: 'anika.carder@company.com',
    phone: '+63 912 345 6794',
  ),
  _MemberData(
    name: 'John Rivera',
    initials: 'JR',
    avatarColor: const Color(0xFF0D9488),
    position: 'QA Analyst',
    department: 'Quality Assurance',
    status: 'Active',
    email: 'john.rivera@company.com',
    phone: '+63 912 345 6795',
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
                      Icons.tune,
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
                    value: _selectedTeam,
                    items: const ['All', 'Team Alpha', 'Team Beta'],
                    onChanged: (v) =>
                        setState(() => _selectedTeam = v ?? 'All'),
                  ),
                  const SizedBox(height: 8),
                  _FilterDropdown(
                    label: 'Reporting To',
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
                      onPressed: () => setState(() {}),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.headerOrange,
                        foregroundColor: Colors.white,
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
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: DropdownButtonFormField<String>(
            value: value,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: GoogleFonts.inter(fontSize: 13)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, size: 18),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textPrimary,
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
    final isActive = member.status == 'Active';
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
                          member.initials,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: member.avatarColor,
                          ),
                        ),
                      ),
                      if (isActive)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
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
                                member.name,
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
                                member.status,
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
                          member.position,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          member.department,
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
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _detailRow(Icons.email_outlined, 'Email', member.email),
                  const SizedBox(height: 8),
                  _detailRow(Icons.phone_outlined, 'Phone', member.phone),
                  const SizedBox(height: 8),
                  _detailRow(
                    Icons.business_outlined,
                    'Department',
                    member.department,
                  ),
                  const SizedBox(height: 8),
                  _detailRow(Icons.work_outline, 'Position', member.position),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
