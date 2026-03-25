import 'package:flutter/material.dart';
import '../../../widgets/request_form_widgets.dart';

class CustomerFinanceTab extends StatefulWidget {
  const CustomerFinanceTab({super.key});

  @override
  State<CustomerFinanceTab> createState() => CustomerFinanceTabState();
}

class CustomerFinanceTabState extends State<CustomerFinanceTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String? _tradingTerms;
  bool _exceptHold = false;
  int _balanceMethod = 0;
  final _taxIdController = TextEditingController();
  String? _defaultRevenueAccount;
  final _creditLimitController = TextEditingController();
  bool _sendStatement = false;
  String? _taxRule;
  String? _accountReceivable;

  List<String> validate() {
    return <String>[];
  }

  Map<String, dynamic> getData() {
    return {
      "tradingTerms": _tradingTerms,
      "exceptHold": _exceptHold ? 1 : 0,
      "balanceMethod": _balanceMethod == 0 ? "Balance Forward" : "Open Method",
      "taxIdentification": _taxIdController.text,
      "defaultRevenueAccount": _defaultRevenueAccount,
      "creditLimit": _creditLimitController.text,
      "sendStatement": _sendStatement ? 1 : 0,
      "taxRule": _taxRule,
      "accountReceivable": _accountReceivable,
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
          const FormTabTitle("Finance Tab"),
          const SizedBox(height: 6),
          const FormTabDescription(
            "Finance Tab records customer billing and accounting preferences.",
          ),
          const SizedBox(height: 20),
          FormDropdownField(
            hint: "Trading Terms",
            value: _tradingTerms,
            items: const ["Net 30", "Net 60", "Net 90", "COD"],
            onChanged: (v) => setState(() => _tradingTerms = v),
          ),
          const SizedBox(height: 16),
          FormSwitchRow(
            label: "Except Hold",
            value: _exceptHold,
            onChanged: (v) => setState(() => _exceptHold = v),
          ),
          const SizedBox(height: 12),
          const FormSectionLabel("Balance Forward or Open Method"),
          const SizedBox(height: 8),
          Row(
            children: [
              FormRadioOption(
                label: "Balance Forward",
                value: 0,
                groupValue: _balanceMethod,
                onChanged: (v) => setState(() => _balanceMethod = v),
              ),
              const SizedBox(width: 20),
              FormRadioOption(
                label: "Open Method",
                value: 1,
                groupValue: _balanceMethod,
                onChanged: (v) => setState(() => _balanceMethod = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FormTextField(controller: _taxIdController, hint: "Tax Identification"),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Default Revenue Account",
            value: _defaultRevenueAccount,
            items: const ["Account A", "Account B", "Account C"],
            onChanged: (v) => setState(() => _defaultRevenueAccount = v),
          ),
          const SizedBox(height: 12),
          FormTextField(controller: _creditLimitController, hint: "Credit Limit"),
          const SizedBox(height: 16),
          FormSwitchRow(
            label: "Send Statement",
            value: _sendStatement,
            onChanged: (v) => setState(() => _sendStatement = v),
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Tax Rule",
            value: _taxRule,
            items: const ["Standard", "Exempt", "Reduced"],
            onChanged: (v) => setState(() => _taxRule = v),
          ),
          const SizedBox(height: 12),
          FormDropdownField(
            hint: "Account Receivable",
            value: _accountReceivable,
            items: const ["AR Account 1", "AR Account 2", "AR Account 3"],
            onChanged: (v) => setState(() => _accountReceivable = v),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taxIdController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }
}
