import 'package:flutter/material.dart';
import '../../../widgets/request_form_widgets.dart';
import 'tab_list_card.dart';

class CustomerAddressTab extends StatefulWidget {
  const CustomerAddressTab({super.key});

  @override
  State<CustomerAddressTab> createState() => CustomerAddressTabState();
}

class CustomerAddressTabState extends State<CustomerAddressTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, String>> _addresses = [];

  List<String> validate() {
    return <String>[];
  }

  Map<String, dynamic> getData() {
    return {"addresses": _addresses};
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Address Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Address Tab stores customer location entries for billing and delivery.",
          ),
          const SizedBox(height: 20),
          FormAddButton(
            label: "Add Address",
            onPressed: () {
              setState(() {
                _addresses.add({'address': 'New Address'});
              });
            },
          ),
          if (_addresses.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._addresses.asMap().entries.map(
              (entry) => CustomerTabListCard(
                title: "Address ${entry.key + 1}",
                icon: Icons.location_on_outlined,
                onRemove: () => setState(() => _addresses.removeAt(entry.key)),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
