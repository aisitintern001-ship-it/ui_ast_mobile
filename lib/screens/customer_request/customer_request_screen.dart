import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/request_address_tabs.dart';
import '../../widgets/request_contacts_tabs.dart';
import '../../widgets/request_documents_tabs.dart';
import '../../widgets/request_form_widgets.dart';
import 'tabs/attribute_tab.dart';
import 'tabs/finance_tab.dart';
import '../../widgets/request_identification_tabs.dart';
import 'tabs/requirements_tab.dart';

class CreateCustomerRequestScreen extends StatefulWidget {
  const CreateCustomerRequestScreen({super.key});

  @override
  State<CreateCustomerRequestScreen> createState() =>
      _CreateCustomerRequestScreenState();
}

class _CreateCustomerRequestScreenState extends State<CreateCustomerRequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _identificationKey = GlobalKey<RequestIdentificationTabState>();
  final _attributeKey = GlobalKey<CustomerAttributeTabState>();
  final _contactsKey = GlobalKey<RequestContactsTabState>();
  final _addressKey = GlobalKey<RequestAddressTabState>();
  final _financeKey = GlobalKey<CustomerFinanceTabState>();
  final _requirementsKey = GlobalKey<CustomerRequirementsTabState>();
  final _documentsKey = GlobalKey<RequestDocumentsTabState>();

  static const _tabLabels = [
    'Identification',
    'Attribute',
    'Contacts',
    'Address',
    'Finance',
    'Requirements',
    'Documents',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> _validateAll() {
    final errors = <String>[];

    final idTab = _identificationKey.currentState;
    final attrTab = _attributeKey.currentState;
    final contactsTab = _contactsKey.currentState;
    final addressTab = _addressKey.currentState;
    final financeTab = _financeKey.currentState;
    final requirementsTab = _requirementsKey.currentState;
    final documentsTab = _documentsKey.currentState;

    if (idTab != null) {
      errors.addAll(idTab.validate().map((e) => "Identification: $e"));
    }
    if (attrTab != null) {
      errors.addAll(attrTab.validate().map((e) => "Attribute: $e"));
    }
    if (contactsTab != null) {
      errors.addAll(contactsTab.validate().map((e) => "Contacts: $e"));
    }
    if (addressTab != null) {
      errors.addAll(addressTab.validate().map((e) => "Address: $e"));
    }
    if (financeTab != null) {
      errors.addAll(financeTab.validate().map((e) => "Finance: $e"));
    }
    if (requirementsTab != null) {
      errors.addAll(requirementsTab.validate().map((e) => "Requirements: $e"));
    }
    if (documentsTab != null) {
      errors.addAll(documentsTab.validate().map((e) => "Documents: $e"));
    }

    return errors;
  }

  Map<String, dynamic> _collectData() {
    return {
      "identification": _identificationKey.currentState?.getData(),
      "attribute": _attributeKey.currentState?.getData(),
      "contacts": _contactsKey.currentState?.getData(),
      "address": _addressKey.currentState?.getData(),
      "finance": _financeKey.currentState?.getData(),
      "requirements": _requirementsKey.currentState?.getData(),
      "documents": _documentsKey.currentState?.getData(),
    };
  }

  void _saveDraft() {
    final data = _collectData();
    debugPrint("CUSTOMER DRAFT DATA: $data");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved as draft!', style: GoogleFonts.inter()),
        backgroundColor: Colors.grey.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submit() {
    final errors = _validateAll();
    if (errors.isNotEmpty) {
      _showErrors(errors);
      return;
    }

    final data = _collectData();
    debugPrint("CUSTOMER FINAL DATA: $data");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Customer request submitted!', style: GoogleFonts.inter()),
        backgroundColor: AppColors.statusApproved,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  void _showErrors(List<String> errors) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Missing Fields",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errors
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text("• $e", style: GoogleFonts.inter()),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
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
          'Create Customer Request',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          FormTabBar(controller: _tabController, labels: _tabLabels),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RequestIdentificationTab(key: _identificationKey, entityType: "customer"),
                CustomerAttributeTab(key: _attributeKey),
                RequestContactsTab(key: _contactsKey, entityName: "customer"),
                RequestAddressTab(key: _addressKey, entityName: "customer"),
                CustomerFinanceTab(key: _financeKey),
                CustomerRequirementsTab(key: _requirementsKey),
                RequestDocumentsTab(key: _documentsKey, entityName: "customer"),
              ],
            ),
          ),
          FormBottomActions(
            onSaveDraft: _saveDraft,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }
}
