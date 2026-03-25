import 'package:flutter/material.dart';
import '../../../widgets/request_form_widgets.dart';

class CustomerAttributeTab extends StatefulWidget {
  const CustomerAttributeTab({super.key});

  @override
  State<CustomerAttributeTab> createState() => CustomerAttributeTabState();
}

class CustomerAttributeTabState extends State<CustomerAttributeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _purchaseOrderRequired = false;
  bool _mailingList = false;
  bool _invoiceWithGoods = false;
  bool _acceptPartDeliveries = false;
  bool _indentOrders = false;
  bool _jobLoggingNotRequired = false;
  bool _autoEmailInvoice = false;
  bool _acceptBackOrders = false;
  bool _roundSalesOrder = false;
  bool _allowMultiplePickingSlips = false;

  List<String> validate() {
    return <String>[];
  }

  Map<String, dynamic> getData() {
    return {
      "purchaseOrderRequired": _purchaseOrderRequired ? 1 : 0,
      "mailingList": _mailingList ? 1 : 0,
      "invoiceWithGoods": _invoiceWithGoods ? 1 : 0,
      "acceptPartDeliveries": _acceptPartDeliveries ? 1 : 0,
      "indentOrders": _indentOrders ? 1 : 0,
      "jobLoggingNotRequired": _jobLoggingNotRequired ? 1 : 0,
      "autoEmailInvoice": _autoEmailInvoice ? 1 : 0,
      "acceptBackOrders": _acceptBackOrders ? 1 : 0,
      "roundSalesOrder": _roundSalesOrder ? 1 : 0,
      "allowMultiplePickingSlips": _allowMultiplePickingSlips ? 1 : 0,
    };
  }

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
            "Attributes Tab records customer account behavior and transaction preferences.",
          ),
          const SizedBox(height: 20),
          FormSwitchRow(
            label: "Purchase Order Required",
            value: _purchaseOrderRequired,
            onChanged: (v) => setState(() => _purchaseOrderRequired = v),
          ),
          FormSwitchRow(
            label: "Mailing List",
            value: _mailingList,
            onChanged: (v) => setState(() => _mailingList = v),
          ),
          FormSwitchRow(
            label: "Invoice with Goods",
            value: _invoiceWithGoods,
            onChanged: (v) => setState(() => _invoiceWithGoods = v),
          ),
          FormSwitchRow(
            label: "Accept Part Deliveries",
            value: _acceptPartDeliveries,
            onChanged: (v) => setState(() => _acceptPartDeliveries = v),
          ),
          FormSwitchRow(
            label: "Indent Orders for this Customer",
            value: _indentOrders,
            onChanged: (v) => setState(() => _indentOrders = v),
          ),
          FormSwitchRow(
            label: "Job Logging Order Not Required",
            value: _jobLoggingNotRequired,
            onChanged: (v) => setState(() => _jobLoggingNotRequired = v),
          ),
          FormSwitchRow(
            label: "Auto E-mail Invoice to Customer",
            value: _autoEmailInvoice,
            onChanged: (v) => setState(() => _autoEmailInvoice = v),
          ),
          FormSwitchRow(
            label: "Accept Back Orders",
            value: _acceptBackOrders,
            onChanged: (v) => setState(() => _acceptBackOrders = v),
          ),
          FormSwitchRow(
            label: "Round Sales Order Qty. to Whole Cartons",
            value: _roundSalesOrder,
            onChanged: (v) => setState(() => _roundSalesOrder = v),
          ),
          FormSwitchRow(
            label: "Allow Multiple Picking Slips per Invoice",
            value: _allowMultiplePickingSlips,
            onChanged: (v) => setState(() => _allowMultiplePickingSlips = v),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
