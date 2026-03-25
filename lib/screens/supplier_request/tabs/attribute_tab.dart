import 'package:flutter/material.dart';
import '../../../widgets/request_form_widgets.dart';

class SupplierAttributeTab extends StatefulWidget {
  const SupplierAttributeTab({super.key});

  @override
  State<SupplierAttributeTab> createState() => SupplierAttributeTabState();
}

class SupplierAttributeTabState extends State<SupplierAttributeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ================= STATE =================
  bool _autoEmailOrder = false;
  bool _acceptBulkOrders = false;
  bool _acceptPartDeliveries = false;
  bool _roundPurchasedOrders = false;
  String? _selectedShippingMethod;
  String? _selectedShippingRegion;

  // ================= VALIDATION =================
  List<String> validate() {
    final missing = <String>[];
    // Add validation rules as needed
    return missing;
  }

  // ================= DATA =================
  Map<String, dynamic> getData() {
    return {
      "autoEmailOrder": _autoEmailOrder ? 1 : 0,
      "acceptBulkOrders": _acceptBulkOrders ? 1 : 0,
      "acceptPartDeliveries": _acceptPartDeliveries ? 1 : 0,
      "roundPurchasedOrders": _roundPurchasedOrders ? 1 : 0,
      "shippingMethod": _selectedShippingMethod,
      "shippingRegion": _selectedShippingRegion,
    };
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormTabTitle("Attributes Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Attributes Tab records the supplier's basic details and information about the industry or sector in which they operate, which helps identify and categorize the supplier within the system.",
          ),
          const SizedBox(height: 20),

          FormSwitchRow(
            label: "Customer Auto Email Order to Supplier",
            value: _autoEmailOrder,
            onChanged: (v) => setState(() => _autoEmailOrder = v),
          ),
          FormSwitchRow(
            label: "Accept Bulk Orders",
            value: _acceptBulkOrders,
            onChanged: (v) => setState(() => _acceptBulkOrders = v),
          ),
          FormSwitchRow(
            label: "Accept Part Deliveries",
            value: _acceptPartDeliveries,
            onChanged: (v) => setState(() => _acceptPartDeliveries = v),
          ),
          FormSwitchRow(
            label: "Round Purchased Orders to Whole Cartoons",
            value: _roundPurchasedOrders,
            onChanged: (v) => setState(() => _roundPurchasedOrders = v),
          ),
          const SizedBox(height: 16),

          FormDropdownField(
            hint: "Normal Shipping Method",
            value: _selectedShippingMethod,
            items: const [
              "Overseas Sea Freight",
              "Overseas Air Freight",
              "Local Pick-up",
              "Local Supplier Delivery",
            ],
            onChanged: (v) => setState(() => _selectedShippingMethod = v),
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Shipping Region",
            value: _selectedShippingRegion,
            items: const [
              "Southeast Asia",
              "East Asia",
              "South Asia",
              "Oceania",
              "Middle East",
              "Western Europe",
              "Europe Eastern & Central",
              "North America",
              "Latin America & Caribbean",
              "Africa North",
              "Africa Sub-Saharan",
            ],
            onChanged: (v) => setState(() => _selectedShippingRegion = v),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
