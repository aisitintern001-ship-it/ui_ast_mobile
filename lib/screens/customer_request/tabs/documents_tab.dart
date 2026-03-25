import 'package:flutter/material.dart';
import '../../../widgets/request_form_widgets.dart';
import 'tab_list_card.dart';

class CustomerDocumentsTab extends StatefulWidget {
  const CustomerDocumentsTab({super.key});

  @override
  State<CustomerDocumentsTab> createState() => CustomerDocumentsTabState();
}

class CustomerDocumentsTabState extends State<CustomerDocumentsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, String>> _documents = [];

  List<String> validate() {
    return <String>[];
  }

  Map<String, dynamic> getData() {
    return {"documents": _documents};
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Documents Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Documents Tab stores required attachments and records for customers.",
          ),
          const SizedBox(height: 20),
          FormAddButton(
            label: "Add Document",
            onPressed: () {
              setState(() {
                _documents.add({'name': 'New Document'});
              });
            },
          ),
          if (_documents.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._documents.asMap().entries.map(
              (entry) => CustomerTabListCard(
                title: "Document ${entry.key + 1}",
                icon: Icons.description_outlined,
                onRemove: () => setState(() => _documents.removeAt(entry.key)),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
