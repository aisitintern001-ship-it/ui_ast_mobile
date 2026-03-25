/// Finance section data for Supplier Request
/// Contains dropdown options and data for finance-related fields
library;

class FinanceData {
  /// Trading terms options
  static const List<String> tradingTerms = [
    '30 Day Open Account',
    '7 Day Open Account',
    '14 Day Open Account',
    '60 Day Open Account',
    '90 Day Open Account',
    'Cash on Delivery (COD)',
    'Cash Before Delivery (CBD)',
    'Net 15',
    'Net 30',
    'Net 45',
    'Net 60',
    'Net 90',
  ];

  /// Tax rule options
  static const List<String> taxRules = [
    '30 Day Rule 1',
    'Tax Exempt',
    'VAT on Purchase',
    'VAT on Sales',
    'Standard Rate',
    'Zero Rated',
    'Reduced Rate',
  ];

  /// Account payable options
  static const List<String> accountPayables = [
    'Cash on Hand',
    'Petty Cash Finance',
    'Petty Cash Operations',
    'Accounts Payable - Trade',
    'Accounts Payable - Non-Trade',
    'Accrued Expenses',
    'Notes Payable',
    'Other Payables',
  ];

  /// Payment options
  static const List<String> paymentOptions = [
    'Cash',
    'Bank',
    'GCash',
    'Money Remittance',
  ];

  /// WHT/EWT Rate options
  static const List<String> whtRates = [
    '1% - EWT on Purchase of Goods',
    '2% - EWT on Purchase of Services',
    '5% - EWT on Professional Fees',
    '10% - EWT on Professional Fees',
    '15% - WHT on Dividends',
    '20% - WHT on Royalties',
    '25% - WHT on Interest',
    'Exempt',
  ];

  /// Cost centre options
  static const List<String> costCentres = [
    'Administration',
    'Finance',
    'Human Resources',
    'Information Technology',
    'Marketing',
    'Operations',
    'Production',
    'Quality Assurance',
    'Research & Development',
    'Sales',
    'Warehouse',
  ];

  /// Bank options for Bank Transfer payment
  static const List<String> banks = [
    'BDO Unibank',
    'Bank of the Philippine Islands (BPI)',
    'Metrobank',
    'Land Bank of the Philippines',
    'Philippine National Bank (PNB)',
    'Security Bank',
    'UnionBank',
    'China Banking Corporation',
    'Rizal Commercial Banking Corporation (RCBC)',
    'EastWest Bank',
    'Asia United Bank',
    'Philippine Bank of Communications',
    'Robinsons Bank',
    'Maybank Philippines',
    'CIMB Bank Philippines',
  ];

  /// Remittance center options for Money Remittance payment
  static const List<String> remittanceCenters = [
    'Western Union',
    'M Lhuillier',
    'Cebuana Lhuillier',
    'Palawan Express',
    'LBC',
    'RD Pawnshop',
    'RIA Money Transfer',
    'Xoom',
    'Remitly',
    'WorldRemit',
  ];

  /// Country codes for phone numbers
  static const List<String> countryCodes = [
    '+63',
    '+1',
    '+44',
    '+81',
    '+82',
    '+86',
    '+91',
    '+61',
    '+65',
    '+60',
    '+66',
    '+84',
  ];
}
