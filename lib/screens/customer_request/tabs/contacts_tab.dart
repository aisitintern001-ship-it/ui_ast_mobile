import 'package:flutter/material.dart';
import '../../../widgets/request_form_widgets.dart';
import 'tab_list_card.dart';

class CustomerContactsTab extends StatefulWidget {
  const CustomerContactsTab({super.key});

  @override
  State<CustomerContactsTab> createState() => CustomerContactsTabState();
}

class CustomerContactsTabState extends State<CustomerContactsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, String>> _contacts = [];

  List<String> validate() {
    return <String>[];
  }

  Map<String, dynamic> getData() {
    return {"contacts": _contacts};
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Contacts Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Contacts Tab manages the list of customer contacts for communication.",
          ),
          const SizedBox(height: 20),
          FormAddButton(
            label: "Add Contact",
            onPressed: () {
              setState(() {
                _contacts.add({'name': 'New Contact', 'phone': ''});
              });
            },
          ),
          if (_contacts.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._contacts.asMap().entries.map(
              (entry) => CustomerTabListCard(
                title: "Contact ${entry.key + 1}",
                icon: Icons.person_outline,
                onRemove: () => setState(() => _contacts.removeAt(entry.key)),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
