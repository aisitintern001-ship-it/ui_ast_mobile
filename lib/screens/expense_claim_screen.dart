
import 'package:flutter/material.dart';
import 'expense_claim_dialog.dart';


class ExpenseClaimScreen extends StatefulWidget {
  const ExpenseClaimScreen({super.key});

  @override
  State<ExpenseClaimScreen> createState() => _ExpenseClaimScreenState();
}

class _ExpenseClaimScreenState extends State<ExpenseClaimScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0;
  String _selectedStatus = 'Mngr. Pending';
  final List<String> _statuses = [
    'Mngr. Pending',
    'Mngr. Approved',
    'Mngr. Declined',
    'Pending Finance',
    'Finance Declined',
    'Waiting Payment',
    'Paid by Finance',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Claim'),
        backgroundColor: const Color(0xFFF97316),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Offline'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryTab(context),
          _buildOfflineTab(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const ExpenseClaimDialog(
              employeeName: '',
              category: '',
              description: '',
              amount: '',
            ),
          );
        },
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense Claim'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Records',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _FilterButton(label: 'Last 7 Days', selected: _selectedFilter == 0, onTap: () => setState(() => _selectedFilter = 0))),
            const SizedBox(width: 8),
            Expanded(child: _FilterButton(label: 'Last 30 Days', selected: _selectedFilter == 1, onTap: () => setState(() => _selectedFilter = 1))),
            const SizedBox(width: 8),
            Expanded(child: _FilterButton(label: 'Custom', selected: _selectedFilter == 2, onTap: () => setState(() => _selectedFilter = 2))),
          ],
        ),
        const SizedBox(height: 12),
        _StatusDropdown(
          statuses: _statuses,
          selected: _selectedStatus,
          onChanged: (val) => setState(() => _selectedStatus = val),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text('Apply Filter'),
        ),
        const SizedBox(height: 16),
        _ExpenseClaimCard(
          category: 'Transportation',
          status: 'Manager Pending',
          statusColor: const Color(0xFFFACC15),
          date: 'Jan 24, 2026',
          amount: '₱1,500.00',
          description: 'Taxi fare for client meeting at Makati office. Round trip from home office to client site for quarterly business review presentation.',
          pending: 2,
          approved: 0,
          declined: 0,
          attachments: const ['medical_cert.pdf'],
        ),
        const SizedBox(height: 16),
        _ExpenseClaimCard(
          category: 'Meals',
          status: 'Manager Approved',
          statusColor: const Color(0xFF2563EB),
          date: 'Jan 19, 2026',
          amount: '₱2,160.00',
          description: 'Team lunch for project kickoff meeting. Hosted lunch meeting with 5 team members to discuss Q1 project deliverables.',
          pending: 2,
          approved: 2,
          declined: 0,
          attachments: const ['medical_cert.pdf', 'sampledocs.png'],
        ),
      ],
    );
  }

  Widget _buildOfflineTab(BuildContext context) {
    // Placeholder for offline tab UI
    return Center(child: Text('Offline Records UI here'));
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _FilterButton({required this.label, this.selected = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? const Color(0xFF2563EB) : const Color(0xFFF3F4F6),
        foregroundColor: selected ? Colors.white : const Color(0xFF64748B),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(label),
    );
  }
}

class _StatusDropdown extends StatefulWidget {
  final List<String> statuses;
  final String selected;
  final ValueChanged<String> onChanged;
  const _StatusDropdown({required this.statuses, required this.selected, required this.onChanged});
  @override
  State<_StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<_StatusDropdown> {
  bool _showMenu = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleMenu() {
    if (_showMenu) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    setState(() => _showMenu = !_showMenu);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 8.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.statuses.map((s) {
                  Color dotColor;
                  if (s.contains('Pending')) {
                    dotColor = const Color(0xFF22C55E);
                  } else if (s.contains('Declined')) {
                    dotColor = const Color(0xFFDC2626);
                  } else if (s.contains('Approved') || s.contains('Paid')) {
                    dotColor = const Color(0xFF2563EB);
                  } else {
                    dotColor = const Color(0xFF64748B);
                  }
                  return InkWell(
                    onTap: () {
                      widget.onChanged(s);
                      _toggleMenu();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            widget.selected == s
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: dotColor,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s,
                              style: TextStyle(
                                color: widget.selected == s ? dotColor : const Color(0xFF64748B),
                                fontWeight: widget.selected == s ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.filter_alt_outlined, size: 20, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Filter by Status',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF64748B)),
            ],
          ),
        ),
      ),
    );
  }
}


class _ExpenseClaimCard extends StatelessWidget {
  final String category;
  final String status;
  final Color statusColor;
  final String date;
  final String amount;
  final String description;
  final int pending;
  final int approved;
  final int declined;
  final List<String> attachments;

  const _ExpenseClaimCard({
    required this.category,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.amount,
    required this.description,
    required this.pending,
    required this.approved,
    required this.declined,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(category, style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(status, style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w600)),
                ),
                Spacer(),
                Text(date, style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
            const SizedBox(height: 8),
            Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFDC2626))),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFFFDE68A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Pending: $pending', style: TextStyle(fontSize: 12, color: Color(0xFFB45309))),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Approved: $approved', style: TextStyle(fontSize: 12, color: Color(0xFF059669))),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFFFECACA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Declined: $declined', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Description', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(description, style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            Text('Attachments', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: attachments.map((a) => Chip(label: Text(a), backgroundColor: Color(0xFFF3F4F6))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
